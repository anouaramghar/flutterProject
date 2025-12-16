import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/place.dart';
import '../../providers/place_provider.dart';
import '../../utils/app_styles.dart';
import '../details/place_details_page.dart';

class MapPage extends StatefulWidget {
  final Place? initialPlace;

  const MapPage({super.key, this.initialPlace});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Place? _selectedPlace;

  // Default center: Morocco
  static const LatLng _moroccoCenter = LatLng(31.7917, -7.0926);

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.initialPlace;
  }

  List<Marker> _createMarkers(List<Place> places) {
    return places
        .map(
          (place) => Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPlace = place;
                });
              },
              onDoubleTap: () => _onMarkerInfoTap(place),
              child: Icon(
                Icons.location_on,
                color: AppColors.getCategoryColorFromEnum(place.category),
                size: 32,
              ),
            ),
          ),
        )
        .toList();
  }

  void _onMarkerInfoTap(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceDetailsPage(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.initialPlace != null
          ? AppBar(
              title: Text(widget.initialPlace!.name),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Consumer<PlaceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final initialPosition = widget.initialPlace != null
              ? LatLng(
                  widget.initialPlace!.latitude,
                  widget.initialPlace!.longitude,
                )
              : _moroccoCenter;

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: initialPosition,
                  initialZoom: widget.initialPlace != null ? 14 : 6,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.flutter_application',
                  ),
                  MarkerLayer(
                    markers: _createMarkers(provider.places),
                  ),
                ],
              ),

              // Selected place card at bottom
              if (_selectedPlace != null)
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.lg,
                  child: _buildPlaceCard(_selectedPlace!),
                ),

              // Legend
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: _buildLegend(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceCard(Place place) {
    return GestureDetector(
      onTap: () => _onMarkerInfoTap(place),
      onVerticalDragDown: (_) {
        // Allow user to swipe down to dismiss the card
        setState(() {
          _selectedPlace = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.large,
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.getCategoryColorFromEnum(
                  place.category,
                ).withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                _getCategoryIcon(place.category),
                color: AppColors.getCategoryColorFromEnum(place.category),
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.name,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 2),
                      Text(place.city, style: AppTextStyles.cardSubtitle),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(Icons.star, size: 14, color: AppColors.ratingStar),
                      const SizedBox(width: 2),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: AppTextStyles.cardSubtitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Légende',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _legendItem('Monument', Colors.orange),
          _legendItem('Nature', Colors.green),
          _legendItem('Plage', Colors.cyan),
          _legendItem('Médina', Colors.amber),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.monument:
        return Icons.account_balance;
      case PlaceCategory.plage:
        return Icons.beach_access;
      case PlaceCategory.nature:
        return Icons.park;
      case PlaceCategory.medina:
        return Icons.location_city;
      case PlaceCategory.musee:
        return Icons.museum;
      case PlaceCategory.desert:
        return Icons.landscape;
      case PlaceCategory.montagne:
        return Icons.terrain;
      case PlaceCategory.jardin:
        return Icons.local_florist;
      case PlaceCategory.ville:
      case PlaceCategory.other:
        return Icons.place;
    }
  }
}
