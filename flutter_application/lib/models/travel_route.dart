import 'package:latlong2/latlong.dart';

class RouteStation {
  final String name;
  final String image;
  final LatLng coordinate;
  final String description;

  RouteStation({
    required this.name,
    required this.image,
    required this.coordinate,
    required this.description,
  });
}

class TravelRoute {
  final String title;
  final String duration;
  final String coverImage;
  final List<RouteStation> stations;

  TravelRoute({
    required this.title,
    required this.duration,
    required this.coverImage,
    required this.stations,
  });
}