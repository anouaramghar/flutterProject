import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/place.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_styles.dart';
import '../../widgets/rating_stars.dart';
import 'widgets/image_carrousel.dart';
import 'widgets/info_section.dart';
import '../maps/map_page.dart';
import '../../utils/navigation.dart';

class PlaceDetailsPage extends StatelessWidget {
  final Place place;

  const PlaceDetailsPage({super.key, required this.place});

  Future<void> _openDirections() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openInMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image carousel as app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Consumer<FavoritesProvider>(
                  builder: (context, favorites, _) {
                    final isFav = favorites.isFavorite(place.id);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.error : Colors.white,
                      ),
                      onPressed: () async {
                        await favorites.toggleFavorite(place);
                        final added = favorites.isFavorite(place.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              added
                                  ? '${place.name} ajouté aux favoris'
                                  : '${place.name} retiré des favoris',
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ImageCarousel(images: place.images),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and category
                  Row(
                    children: [
                      Expanded(
                        child: Text(place.name, style: AppTextStyles.h2),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getCategoryColorFromEnum(place.category),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          placeCategoryToDisplayString(place.category),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // City and rating
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        place.city,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      RatingStars(rating: place.rating),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Info sections
                  if (place.hours != null)
                    InfoSection(
                      icon: Icons.access_time,
                      title: 'Horaires',
                      content: place.hours!,
                    ),

                  if (place.price != null)
                    InfoSection(
                      icon: Icons.attach_money,
                      title: 'Tarif',
                      content: '${place.price!.toInt()} MAD',
                    ),

                  // Description
                  const SizedBox(height: AppSpacing.sm),
                  Text('Description', style: AppTextStyles.h4),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    place.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Mini map preview
                  Text('Localisation', style: AppTextStyles.h4),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: _openInMaps,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.textMuted.withOpacity(0.2),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map,
                                  size: 48,
                                  color: AppColors.primary.withOpacity(0.5),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Appuyer pour voir sur Google Maps',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: AppSpacing.md,
                            bottom: AppSpacing.md,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                                boxShadow: AppShadows.small,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.my_location,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                                    style: AppTextStyles.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              buildFadeSlideRoute(
                                MapPage(initialPlace: place),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('Voir sur carte'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openDirections,
                          icon: const Icon(Icons.directions),
                          label: const Text('Y aller'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
