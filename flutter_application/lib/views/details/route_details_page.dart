import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/travel_route.dart';
import '../../utils/app_styles.dart';

class RouteDetailsPage extends StatefulWidget {
  final TravelRoute route;

  const RouteDetailsPage({super.key, required this.route});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  // Cette variable garde en mémoire la station sur laquelle on a cliqué
  RouteStation? _selectedStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. La Carte en plein écran
          FlutterMap(
            options: MapOptions(
              // On centre la carte sur la première station
              initialCenter: widget.route.stations.first.coordinate,
              initialZoom: 7.5,
              onTap: (_, __) {
                // Si on clique ailleurs sur la carte, on ferme la popup
                setState(() => _selectedStation = null);
              },
            ),
            children: [
              // Fond de carte (Style Premium)
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              
              // Dessiner la ligne du trajet
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.route.stations.map((s) => s.coordinate).toList(),
                    strokeWidth: 4.0,
                    color: AppColors.primary,
                  ),
                ],
              ),

              // Dessiner les points (Stations)
              MarkerLayer(
                markers: widget.route.stations.map((station) {
                  return Marker(
                    point: station.coordinate,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedStation = station);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: const Icon(Icons.location_on, color: AppColors.primary, size: 24),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 2. Bouton retour et Titre (flottant en haut)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: Text(
                      widget.route.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. La Popup d'information de la station (s'affiche seulement si une station est sélectionnée)
          if (_selectedStation != null)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: _buildStationPopup(_selectedStation!),
            ),
        ],
      ),
    );
  }

  Widget _buildStationPopup(RouteStation station) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image de la station
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: station.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  station.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Bouton fermer
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => setState(() => _selectedStation = null),
          ),
        ],
      ),
    );
  }
}