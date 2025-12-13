import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/place_service.dart';

class PlaceProvider extends ChangeNotifier {

  final PlaceService _placeService = PlaceService();

  //Liste complète des lieux
  List<Place> _allPlaces = [];

  //Liste affichée (après recherche / filtre)
  List<Place> _places = [];

  //Getter pour l’UI
  List<Place> get places => _places;

  //Indicateur de chargement
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //Charger les lieux depuis le JSON
  Future<void> loadPlaces() async {
    _isLoading = true;
    notifyListeners();

    _allPlaces = await _placeService.loadPlaces();
    _places = _allPlaces;

    _isLoading = false;
    notifyListeners();
  }

  //Recherche par nom
  void searchByName(String query) {
    if (query.isEmpty) {
      _places = _allPlaces;
    } else {
      _places = _allPlaces.where((place) =>
          place.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  //Filtrer par ville
  void filterByCity(String city) {
    _places = _allPlaces.where((place) =>
        place.city == city
    ).toList();
    notifyListeners();
  }

  //Filtrer par catégorie
  void filterByCategory(String category) {
    _places = _allPlaces.where((place) =>
        place.category == category
    ).toList();
    notifyListeners();
  }

  //Réinitialiser les filtres
  void resetFilters() {
    _places = _allPlaces;
    notifyListeners();
  }
}
