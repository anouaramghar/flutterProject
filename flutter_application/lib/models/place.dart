class Place {
  final int id;
  final String name;
  final String city;
  final String category;
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
      category: json['category'],
      description: json['description'],
      images: List<String>.from(json['images']),
      latitude: json['lat'].toDouble(),
      longitude: json['lng'].toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['price'] != null ? json['price'].toDouble() : null,
      hours: json['hours'],
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'category': category,
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
