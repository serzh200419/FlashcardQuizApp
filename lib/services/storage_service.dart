import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../models/quiz_result.dart';

class StorageService {
  static const String _decksKey = 'decks';
  static const String _flashcardsKey = 'flashcards';
  static const String _quizResultsKey = 'quiz_results';

  // Deck operations
  Future<List<Deck>> getDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? decksJson = prefs.getString(_decksKey);
    
    if (decksJson == null) return [];
    
    final List<dynamic> decoded = json.decode(decksJson);
    return decoded.map((json) => Deck.fromJson(json)).toList();
  }

  Future<void> saveDecks(List<Deck> decks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(decks.map((deck) => deck.toJson()).toList());
    await prefs.setString(_decksKey, encoded);
  }

  Future<void> addDeck(Deck deck) async {
    final decks = await getDecks();
    decks.add(deck);
    await saveDecks(decks);
  }

  Future<void> updateDeck(Deck deck) async {
    final decks = await getDecks();
    final index = decks.indexWhere((d) => d.id == deck.id);
    if (index != -1) {
      decks[index] = deck;
      await saveDecks(decks);
    }
  }

  Future<void> deleteDeck(String deckId) async {
    final decks = await getDecks();
    decks.removeWhere((d) => d.id == deckId);
    await saveDecks(decks);
    
    // Also delete all flashcards in this deck
    final flashcards = await getFlashcards();
    final filteredFlashcards = flashcards.where((f) => f.deckId != deckId).toList();
    await saveFlashcards(filteredFlashcards);
  }

  // Flashcard operations
  Future<List<Flashcard>> getFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? flashcardsJson = prefs.getString(_flashcardsKey);
    
    if (flashcardsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(flashcardsJson);
    return decoded.map((json) => Flashcard.fromJson(json)).toList();
  }

  Future<List<Flashcard>> getFlashcardsByDeck(String deckId) async {
    final flashcards = await getFlashcards();
    return flashcards.where((f) => f.deckId == deckId).toList();
  }

  Future<void> saveFlashcards(List<Flashcard> flashcards) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(flashcards.map((fc) => fc.toJson()).toList());
    await prefs.setString(_flashcardsKey, encoded);
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final flashcards = await getFlashcards();
    flashcards.add(flashcard);
    await saveFlashcards(flashcards);
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    final flashcards = await getFlashcards();
    final index = flashcards.indexWhere((f) => f.id == flashcard.id);
    if (index != -1) {
      flashcards[index] = flashcard;
      await saveFlashcards(flashcards);
    }
  }

  Future<void> deleteFlashcard(String flashcardId) async {
    final flashcards = await getFlashcards();
    flashcards.removeWhere((f) => f.id == flashcardId);
    await saveFlashcards(flashcards);
  }

  // Quiz result operations
  Future<List<QuizResult>> getQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultsJson = prefs.getString(_quizResultsKey);
    
    if (resultsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(resultsJson);
    return decoded.map((json) => QuizResult.fromJson(json)).toList();
  }

  Future<List<QuizResult>> getQuizResultsByDeck(String deckId) async {
    final results = await getQuizResults();
    return results.where((r) => r.deckId == deckId).toList();
  }

  Future<void> addQuizResult(QuizResult result) async {
    final results = await getQuizResults();
    results.add(result);
    await saveQuizResults(results);
  }

  Future<void> saveQuizResults(List<QuizResult> results) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(results.map((r) => r.toJson()).toList());
    await prefs.setString(_quizResultsKey, encoded);
  }
}

