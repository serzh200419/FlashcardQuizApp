import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/deck.dart';
import '../widgets/primary_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Deck? _deck;
  bool _quizStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deck = ModalRoute.of(context)?.settings.arguments as Deck?;
      if (deck != null) {
        setState(() {
          _deck = deck;
        });
        _loadQuiz(deck.id);
      }
    });
  }

  void _loadQuiz(String deckId) {
    final flashcardProvider = context.read<FlashcardProvider>();
    final quizProvider = context.read<QuizProvider>();

    flashcardProvider.loadFlashcardsByDeck(deckId).then((_) {
      final flashcards = flashcardProvider.getFlashcardsByDeck(deckId);
      if (flashcards.isNotEmpty) {
        quizProvider.startQuiz(flashcards);
        setState(() {
          _quizStarted = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No flashcards available. Please add flashcards first.'),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  void _handleAnswer(bool isCorrect) {
    final quizProvider = context.read<QuizProvider>();
    final flashcardProvider = context.read<FlashcardProvider>();

    if (isCorrect) {
      quizProvider.recordCorrect();
    } else {
      quizProvider.recordIncorrect();
    }

    quizProvider.submitAnswer(isCorrect);

    // Record the study session
    final currentFlashcard = quizProvider.currentFlashcard;
    if (currentFlashcard != null) {
      flashcardProvider.recordFlashcardStudy(currentFlashcard, isCorrect);
    }
  }

  void _nextQuestion() {
    final quizProvider = context.read<QuizProvider>();
    if (quizProvider.isQuizComplete) {
      _completeQuiz();
    } else {
      quizProvider.nextQuestion();
    }
  }

  Future<void> _completeQuiz() async {
    if (_deck == null) return;

    final quizProvider = context.read<QuizProvider>();
    await quizProvider.completeQuiz(_deck!.id);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _QuizResultDialog(
        totalQuestions: quizProvider.totalQuestions,
        correctAnswers: quizProvider.correctCount,
        accuracy: quizProvider.currentAccuracy,
        onClose: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Close quiz screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_deck == null || !_quizStarted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${_deck!.title}'),
        elevation: 0,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          final currentFlashcard = quizProvider.currentFlashcard;
          if (currentFlashcard == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Progress Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${quizProvider.currentIndex + 1} of ${quizProvider.totalQuestions}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Correct: ${quizProvider.correctCount} | Incorrect: ${quizProvider.incorrectCount}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (quizProvider.currentIndex + 1) /
                          quizProvider.totalQuestions,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Flashcard Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: quizProvider.showAnswer
                              ? [Colors.blue.shade400, Colors.blue.shade600]
                              : [Colors.purple.shade400, Colors.purple.shade600],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            quizProvider.showAnswer ? 'Answer' : 'Question',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            quizProvider.showAnswer
                                ? currentFlashcard.answer
                                : currentFlashcard.question,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (quizProvider.showAnswer) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                quizProvider.selectedAnswer == 'correct'
                                    ? '✓ Correct!'
                                    : '✗ Incorrect',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (!quizProvider.showAnswer) ...[
                      PrimaryButton(
                        text: 'Show Answer',
                        icon: Icons.visibility,
                        onPressed: () {
                          quizProvider.revealAnswer();
                        },
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _handleAnswer(true),
                              icon: const Icon(Icons.check, color: Colors.green),
                              label: const Text('Correct'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: const BorderSide(color: Colors.green),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _handleAnswer(false),
                              icon: const Icon(Icons.close, color: Colors.red),
                              label: const Text('Incorrect'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: quizProvider.isQuizComplete
                            ? 'View Results'
                            : 'Next Question',
                        icon: quizProvider.isQuizComplete
                            ? Icons.done
                            : Icons.arrow_forward,
                        onPressed: _nextQuestion,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuizResultDialog extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;
  final VoidCallback onClose;

  const _QuizResultDialog({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quiz Complete! 🎉'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You got $correctAnswers out of $totalQuestions correct!',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accuracy >= 70 ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Accuracy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${accuracy.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accuracy >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onClose,
          child: const Text('Close'),
        ),
      ],
    );
  }
}

