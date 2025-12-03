import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../widgets/primary_button.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  const AddEditFlashcardScreen({super.key});

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  bool _isLoading = false;
  bool _isEditMode = false;
  Deck? _deck;
  Flashcard? _editingFlashcard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _deck = args['deck'] as Deck?;
          _editingFlashcard = args['flashcard'] as Flashcard?;
          if (_editingFlashcard != null) {
            _isEditMode = true;
            _questionController.text = _editingFlashcard!.question;
            _answerController.text = _editingFlashcard!.answer;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _saveFlashcard() async {
    if (!_formKey.currentState!.validate() || _deck == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final flashcardProvider = context.read<FlashcardProvider>();
      final question = _questionController.text.trim();
      final answer = _answerController.text.trim();

      if (_isEditMode && _editingFlashcard != null) {
        final updatedFlashcard = _editingFlashcard!.copyWith(
          question: question,
          answer: answer,
          updatedAt: DateTime.now(),
        );
        await flashcardProvider.updateFlashcard(updatedFlashcard);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashcard updated successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        final newFlashcard = Flashcard(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          deckId: _deck!.id,
          question: question,
          answer: answer,
          createdAt: DateTime.now(),
        );
        await flashcardProvider.addFlashcard(newFlashcard);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashcard created successfully')),
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
        title: Text(_isEditMode ? 'Edit Flashcard' : 'Add Flashcard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_deck != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.folder, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Deck: ${_deck!.title}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'Enter the question',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.help_outline),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  hintText: 'Enter the answer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle_outline),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: _isEditMode ? 'Update Flashcard' : 'Create Flashcard',
                icon: _isEditMode ? Icons.update : Icons.add,
                onPressed: _saveFlashcard,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

