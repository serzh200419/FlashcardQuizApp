import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/flashcard.dart';
import '../models/quiz_result.dart';
import '../services/storage_service.dart';

class QuizProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Flashcard> _quizFlashcards = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;
  bool _isQuizActive = false;
  bool _showAnswer = false;
  String? _selectedAnswer;

  List<Flashcard> get quizFlashcards => _quizFlashcards;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  int get incorrectCount => _incorrectCount;
  bool get isQuizActive => _isQuizActive;
  bool get showAnswer => _showAnswer;
  String? get selectedAnswer => _selectedAnswer;
  
  Flashcard? get currentFlashcard {
    if (_currentIndex >= 0 && _currentIndex < _quizFlashcards.length) {
      return _quizFlashcards[_currentIndex];
    }
    return null;
  }

  int get totalQuestions => _quizFlashcards.length;
  int get remainingQuestions => _quizFlashcards.length - _currentIndex;
  double get currentAccuracy {
    final total = _correctCount + _incorrectCount;
    if (total == 0) return 0.0;
    return (_correctCount / total) * 100;
  }

  void startQuiz(List<Flashcard> flashcards) {
    if (flashcards.isEmpty) {
      return;
    }
    
    // Shuffle flashcards for random order
    final shuffled = List<Flashcard>.from(flashcards);
    shuffled.shuffle(Random());
    
    _quizFlashcards = shuffled;
    _currentIndex = 0;
    _correctCount = 0;
    _incorrectCount = 0;
    _isQuizActive = true;
    _showAnswer = false;
    _selectedAnswer = null;
    notifyListeners();
  }

  void revealAnswer() {
    _showAnswer = true;
    notifyListeners();
  }

  void submitAnswer(bool isCorrect) {
    if (!_showAnswer) {
      revealAnswer();
    }
    
    _selectedAnswer = isCorrect ? 'correct' : 'incorrect';
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _quizFlashcards.length - 1) {
      _currentIndex++;
      _showAnswer = false;
      _selectedAnswer = null;
      notifyListeners();
    }
  }

  void recordCorrect() {
    _correctCount++;
    notifyListeners();
  }

  void recordIncorrect() {
    _incorrectCount++;
    notifyListeners();
  }

  bool get isQuizComplete {
    return _currentIndex >= _quizFlashcards.length - 1 && _showAnswer;
  }

  Future<void> completeQuiz(String deckId) async {
    if (!_isQuizActive) return;
    
    try {
      final result = QuizResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        deckId: deckId,
        totalQuestions: totalQuestions,
        correctAnswers: _correctCount,
        completedAt: DateTime.now(),
      );
      
      await _storageService.addQuizResult(result);
      
      _isQuizActive = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing quiz: $e');
    }
  }

  void resetQuiz() {
    _quizFlashcards = [];
    _currentIndex = 0;
    _correctCount = 0;
    _incorrectCount = 0;
    _isQuizActive = false;
    _showAnswer = false;
    _selectedAnswer = null;
    notifyListeners();
  }
}

