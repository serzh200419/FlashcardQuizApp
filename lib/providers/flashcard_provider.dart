import 'package:flutter/foundation.dart';
import '../models/flashcard.dart';
import '../services/storage_service.dart';

class FlashcardProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Flashcard> _flashcards = [];
  bool _isLoading = false;

  List<Flashcard> get flashcards => _flashcards;
  bool get isLoading => _isLoading;

  int get totalFlashcards => _flashcards.length;

  Future<void> loadFlashcards() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _flashcards = await _storageService.getFlashcards();
    } catch (e) {
      debugPrint('Error loading flashcards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFlashcardsByDeck(String deckId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _flashcards = await _storageService.getFlashcardsByDeck(deckId);
    } catch (e) {
      debugPrint('Error loading flashcards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    try {
      await _storageService.addFlashcard(flashcard);
      _flashcards.add(flashcard);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding flashcard: $e');
      rethrow;
    }
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    try {
      final updatedFlashcard = flashcard.copyWith(updatedAt: DateTime.now());
      await _storageService.updateFlashcard(updatedFlashcard);
      final index = _flashcards.indexWhere((f) => f.id == flashcard.id);
      if (index != -1) {
        _flashcards[index] = updatedFlashcard;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating flashcard: $e');
      rethrow;
    }
  }

  Future<void> deleteFlashcard(String flashcardId) async {
    try {
      await _storageService.deleteFlashcard(flashcardId);
      _flashcards.removeWhere((f) => f.id == flashcardId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting flashcard: $e');
      rethrow;
    }
  }

  Future<void> recordFlashcardStudy(Flashcard flashcard, bool wasCorrect) async {
    try {
      final updatedFlashcard = flashcard.copyWith(
        timesStudied: flashcard.timesStudied + 1,
        timesCorrect: wasCorrect ? flashcard.timesCorrect + 1 : flashcard.timesCorrect,
        updatedAt: DateTime.now(),
      );
      await _storageService.updateFlashcard(updatedFlashcard);
      final index = _flashcards.indexWhere((f) => f.id == flashcard.id);
      if (index != -1) {
        _flashcards[index] = updatedFlashcard;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error recording flashcard study: $e');
    }
  }

  List<Flashcard> getFlashcardsByDeck(String deckId) {
    return _flashcards.where((f) => f.deckId == deckId).toList();
  }
}

