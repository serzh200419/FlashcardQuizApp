import 'package:flutter/foundation.dart';
import '../models/deck.dart';
import '../services/storage_service.dart';

class DeckProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Deck> _decks = [];
  bool _isLoading = false;

  List<Deck> get decks => _decks;
  bool get isLoading => _isLoading;

  int get totalDecks => _decks.length;

  Future<void> loadDecks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _decks = await _storageService.getDecks();
    } catch (e) {
      debugPrint('Error loading decks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDeck(Deck deck) async {
    try {
      await _storageService.addDeck(deck);
      _decks.add(deck);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding deck: $e');
      rethrow;
    }
  }

  Future<void> updateDeck(Deck deck) async {
    try {
      final updatedDeck = deck.copyWith(updatedAt: DateTime.now());
      await _storageService.updateDeck(updatedDeck);
      final index = _decks.indexWhere((d) => d.id == deck.id);
      if (index != -1) {
        _decks[index] = updatedDeck;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating deck: $e');
      rethrow;
    }
  }

  Future<void> deleteDeck(String deckId) async {
    try {
      await _storageService.deleteDeck(deckId);
      _decks.removeWhere((d) => d.id == deckId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting deck: $e');
      rethrow;
    }
  }

  Deck? getDeckById(String id) {
    try {
      return _decks.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }
}

