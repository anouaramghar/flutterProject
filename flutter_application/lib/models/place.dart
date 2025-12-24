enum PlaceCategory {
  monument,
  plage,
  nature,
  medina,
  musee,
  desert,
  montagne,
  jardin,
  ville,

  /// Fallback when the category string is unknown or missing.
  other,
}

PlaceCategory placeCategoryFromString(String value) {
  switch (value.toLowerCase()) {
    case 'monument':
      return PlaceCategory.monument;
    case 'plage':
      return PlaceCategory.plage;
    case 'nature':
      return PlaceCategory.nature;
    case 'médina':
    case 'medina':
      return PlaceCategory.medina;
    case 'musée':
    case 'musee':
      return PlaceCategory.musee;
    case 'désert':
    case 'desert':
      return PlaceCategory.desert;
    case 'montagne':
      return PlaceCategory.montagne;
    case 'jardin':
      return PlaceCategory.jardin;
    case 'ville':
      return PlaceCategory.ville;
    default:
      return PlaceCategory.other;
  }
}

String placeCategoryToDisplayString(PlaceCategory category) {
  switch (category) {
    case PlaceCategory.monument:
      return 'Monument';
    case PlaceCategory.plage:
      return 'Plage';
    case PlaceCategory.nature:
      return 'Nature';
    case PlaceCategory.medina:
      return 'Médina';
    case PlaceCategory.musee:
      return 'Musée';
    case PlaceCategory.desert:
      return 'Désert';
    case PlaceCategory.montagne:
      return 'Montagne';
    case PlaceCategory.jardin:
      return 'Jardin';
    case PlaceCategory.ville:
      return 'Ville';
    case PlaceCategory.other:
      return 'Autre';
  }
}

class Place {
  final int id;
  final String name;
  final String city;
  final PlaceCategory category;
  final String description;
  final List<String> images;
  final double latitude;
  final double longitude;
  final double rating;
  final double? price;
  final String? hours;

  Place({
    required this.id,
    required this.name,
    required this.city,
    required this.category,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.price,
    this.hours,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      category: placeCategoryFromString(json['category'] as String),
      description: json['description'],
      images: List<String>.from(json['images']),
      latitude: json['lat'].toDouble(),
      longitude: json['lng'].toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['price']?.toDouble(),
      hours: json['hours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'category': placeCategoryToDisplayString(category),
      'description': description,
      'images': images,
      'lat': latitude,
      'lng': longitude,
      'rating': rating,
      'price': price,
      'hours': hours,
    };
  }
}
