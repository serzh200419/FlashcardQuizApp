import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../models/deck.dart';
import '../widgets/primary_button.dart';

class AddEditDeckScreen extends StatefulWidget {
  const AddEditDeckScreen({super.key});

  @override
  State<AddEditDeckScreen> createState() => _AddEditDeckScreenState();
}

class _AddEditDeckScreenState extends State<AddEditDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _isLoading = false;
  bool _isEditMode = false;
  Deck? _editingDeck;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deck = ModalRoute.of(context)?.settings.arguments as Deck?;
      if (deck != null) {
        _isEditMode = true;
        _editingDeck = deck;
        _titleController.text = deck.title;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveDeck() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final deckProvider = context.read<DeckProvider>();
      final title = _titleController.text.trim();

      if (_isEditMode && _editingDeck != null) {
        final updatedDeck = _editingDeck!.copyWith(
          title: title,
          updatedAt: DateTime.now(),
        );
        await deckProvider.updateDeck(updatedDeck);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deck updated successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        final newDeck = Deck(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          createdAt: DateTime.now(),
        );
        await deckProvider.addDeck(newDeck);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deck created successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Deck' : 'Add Deck'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Deck Title',
                  hintText: 'Enter deck title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a deck title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: _isEditMode ? 'Update Deck' : 'Create Deck',
                icon: _isEditMode ? Icons.update : Icons.add,
                onPressed: _saveDeck,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

