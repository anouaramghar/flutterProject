import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  Place? _selectedPlace;

  // Default center: Morocco
  static const LatLng _moroccoCenter = LatLng(31.7917, -7.0926);

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.initialPlace;
  }

  Set<Marker> _createMarkers(List<Place> places) {
    return places.map((place) {
      return Marker(
        markerId: MarkerId(place.id.toString()),
        position: LatLng(place.latitude, place.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerHue(place.category),
        ),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: '${place.city} • ${place.category}',
          onTap: () => _onMarkerInfoTap(place),
        ),
        onTap: () {
          setState(() {
            _selectedPlace = place;
          });
        },
      );
    }).toSet();
  }

  double _getMarkerHue(String category) {
    switch (category.toLowerCase()) {
      case 'monument':
        return BitmapDescriptor.hueOrange;
      case 'plage':
        return BitmapDescriptor.hueCyan;
      case 'nature':
        return BitmapDescriptor.hueGreen;
      case 'médina':
      case 'medina':
        return BitmapDescriptor.hueYellow;
      case 'musée':
      case 'musee':
        return BitmapDescriptor.hueViolet;
      case 'désert':
      case 'desert':
        return BitmapDescriptor.hueRose;
      case 'montagne':
        return BitmapDescriptor.hueBlue;
      case 'jardin':
        return BitmapDescriptor.hueGreen;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _onMarkerInfoTap(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceDetailsPage(place: place)),
    );
  }

  void _goToPlace(Place place) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(place.latitude, place.longitude), 14),
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
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: widget.initialPlace != null ? 14 : 6,
                ),
                markers: _createMarkers(provider.places),
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (widget.initialPlace != null) {
                    _goToPlace(widget.initialPlace!);
                  }
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: true,
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
                color: AppColors.getCategoryColor(
                  place.category,
                ).withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                _getCategoryIcon(place.category),
                color: AppColors.getCategoryColor(place.category),
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'monument':
        return Icons.account_balance;
      case 'plage':
        return Icons.beach_access;
      case 'nature':
        return Icons.park;
      case 'médina':
      case 'medina':
        return Icons.location_city;
      case 'musée':
      case 'musee':
        return Icons.museum;
      case 'désert':
      case 'desert':
        return Icons.landscape;
      case 'montagne':
        return Icons.terrain;
      case 'jardin':
        return Icons.local_florist;
      default:
        return Icons.place;
    }
  }
}
