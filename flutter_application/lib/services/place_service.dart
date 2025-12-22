import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/place.dart';

class PlaceService {

  /// Charger les lieux depuis le fichier JSON local
  Future<List<Place>> loadPlaces() async {

    //Lire le fichier JSON depuis les assets
    final String jsonString =
        await rootBundle.loadString('assets/data/places.json');

    //Convertir le JSON  string en Map
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    //Récupérer la liste des lieux
    final List placesJson = jsonData['places'];

    //Convertir chaque lieu JSON en objet Place
    return placesJson
        .map((placeJson) => Place.fromJson(placeJson))
        .toList();
  }
}
