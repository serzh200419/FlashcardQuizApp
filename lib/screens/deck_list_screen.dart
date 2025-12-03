import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/deck.dart';
import '../widgets/deck_card.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/primary_button.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeckProvider>().loadDecks();
      context.read<FlashcardProvider>().loadFlashcards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
        elevation: 0,
      ),
      body: Consumer2<DeckProvider, FlashcardProvider>(
        builder: (context, deckProvider, flashcardProvider, child) {
          if (deckProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final decks = deckProvider.decks;

          if (decks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No decks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first deck to get started!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              final flashcardCount = flashcardProvider
                  .getFlashcardsByDeck(deck.id)
                  .length;

              return DeckCard(
                deck: deck,
                flashcardCount: flashcardCount,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/flashcards',
                    arguments: deck,
                  );
                },
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    '/addDeck',
                    arguments: deck,
                  );
                },
                onDelete: () {
                  _showDeleteDialog(context, deck, deckProvider);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addDeck');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Deck'),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Deck deck,
    DeckProvider deckProvider,
  ) {
    ConfirmDialog.show(
      context,
      title: 'Delete Deck',
      message: 'Are you sure you want to delete "${deck.title}"? This will also delete all flashcards in this deck.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    ).then((confirmed) {
      if (confirmed == true) {
        deckProvider.deleteDeck(deck.id).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deck deleted successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting deck: $error')),
          );
        });
      }
    });
  }
}

