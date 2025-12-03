import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/primary_button.dart';

class FlashcardListScreen extends StatefulWidget {
  const FlashcardListScreen({super.key});

  @override
  State<FlashcardListScreen> createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  Deck? _deck;
  final Map<String, bool> _expandedCards = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deck = ModalRoute.of(context)?.settings.arguments as Deck?;
      if (deck != null) {
        setState(() {
          _deck = deck;
        });
        context.read<FlashcardProvider>().loadFlashcardsByDeck(deck.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_deck == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_deck!.title),
        elevation: 0,
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, child) {
          if (flashcardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final flashcards = flashcardProvider.getFlashcardsByDeck(_deck!.id);

          if (flashcards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No flashcards yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first flashcard to get started!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Start Quiz Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryButton(
                  text: 'Start Quiz',
                  icon: Icons.play_arrow,
                  onPressed: flashcards.isEmpty
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            '/quiz',
                            arguments: _deck,
                          );
                        },
                ),
              ),
              // Flashcard List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    final flashcard = flashcards[index];
                    final isExpanded = _expandedCards[flashcard.id] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          flashcard.question,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Accuracy: ${flashcard.accuracy.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: flashcard.accuracy >= 70
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Answer:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(flashcard.answer),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/addFlashcard',
                                          arguments: {
                                            'deck': _deck,
                                            'flashcard': flashcard,
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Edit'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        _showDeleteDialog(
                                          context,
                                          flashcard,
                                          flashcardProvider,
                                        );
                                      },
                                      icon: const Icon(Icons.delete, size: 16),
                                      label: const Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/addFlashcard',
            arguments: {'deck': _deck},
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Flashcard'),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Flashcard flashcard,
    FlashcardProvider flashcardProvider,
  ) {
    ConfirmDialog.show(
      context,
      title: 'Delete Flashcard',
      message: 'Are you sure you want to delete this flashcard?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    ).then((confirmed) {
      if (confirmed == true) {
        flashcardProvider.deleteFlashcard(flashcard.id).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashcard deleted successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting flashcard: $error')),
          );
        });
      }
    });
  }
}

