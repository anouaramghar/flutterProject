import 'package:flutter/material.dart';
import '../services/favorites_db.dart';
import '../models/place.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesDB _db = FavoritesDB();

  List<Place> _favorites = [];
  bool _isLoading = false;

  List<Place> get favorites => _favorites;
  bool get isLoading => _isLoading;

  /// Initialize and load favorites from SQLite
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _db.getFavorites();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favorites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if a place is in favorites
  bool isFavorite(int placeId) {
    return _favorites.any((place) => place.id == placeId);
  }

  /// Add a place to favorites
  Future<void> addFavorite(Place place) async {
    try {
      await _db.addFavorite(place);
      _favorites.add(place);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  /// Remove a place from favorites
  Future<void> removeFavorite(int placeId) async {
    try {
      await _db.removeFavorite(placeId);
      _favorites.removeWhere((place) => place.id == placeId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Place place) async {
    if (isFavorite(place.id)) {
      await removeFavorite(place.id);
    } else {
      await addFavorite(place);
    }
  }
}
