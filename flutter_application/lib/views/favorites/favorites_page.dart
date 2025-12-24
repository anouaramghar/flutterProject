import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/favorites_provider.dart';
import '../../models/place.dart';
import '../../utils/app_styles.dart';
import '../../widgets/rating_stars.dart';
import '../../utils/navigation.dart';
import '../details/place_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(
                context,
                isDark,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
              // Favorites List
              Expanded(
                child: Consumer<FavoritesProvider>(
                  builder: (context, provider, _) {
                    if (provider.favorites.isEmpty) {
                      return _buildEmptyState(isDark);
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: provider.favorites.length,
                      itemBuilder: (context, index) {
                        final place = provider.favorites[index];
                        return Dismissible(
                          key: Key('favorite_${place.id}'),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _showDeleteConfirmation(
                              context,
                              place,
                              isDark,
                            );
                          },
                          onDismissed: (_) {
                            provider.toggleFavorite(place);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${place.name} retiré des favoris',
                                ),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'Annuler',
                                  onPressed: () =>
                                      provider.toggleFavorite(place),
                                ),
                              ),
                            );
                          },
                          background: _buildDismissBackground(),
                          child: _buildFavoriteCard(context, place, isDark)
                              .animate(delay: (index * 50).ms)
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: 0.1),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: isDark ? null : AppShadows.subtle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? Colors.white : AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Title with icon badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppShadows.coloredShadow(AppColors.primary),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes Favoris',
                    style: AppTextStyles.h3.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Consumer<FavoritesProvider>(
                    builder: (context, provider, _) {
                      return Text(
                        '${provider.favorites.length} lieu${provider.favorites.length > 1 ? 'x' : ''} sauvegardé${provider.favorites.length > 1 ? 's' : ''}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isDark ? Colors.white60 : AppColors.textMuted,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Aucun favori',
            style: AppTextStyles.h3.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'Explorez les lieux et appuyez sur le cœur pour les ajouter ici',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white60 : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Supprimer',
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    Place place,
    bool isDark,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: Text(
          'Retirer des favoris ?',
          style: AppTextStyles.h4.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Voulez-vous vraiment retirer "${place.name}" de vos favoris ?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Annuler',
              style: AppTextStyles.button.copyWith(
                color: isDark ? Colors.white60 : AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Text(
              'Retirer',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Place place, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        buildFadeSlideRoute(PlaceDetailsPage(place: place)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: isDark ? null : AppShadows.small,
        ),
        child: Row(
          children: [
            // Image
            Hero(
              tag: 'place_image_${place.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  bottomLeft: Radius.circular(AppRadius.xl),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: place.images.isNotEmpty
                          ? place.images.first
                          : '',
                      width: 120,
                      height: 130,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.surfaceVariant,
                        child: Center(
                          child: Icon(
                            Icons.image_rounded,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textMuted.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.surfaceVariant,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),

                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getCategoryColorFromEnum(
                          place.category,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        placeCategoryToDisplayString(place.category),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.getCategoryColorFromEnum(
                            place.category,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Name
                    Text(
                      place.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // City
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: isDark ? Colors.white60 : AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.city,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark
                                ? Colors.white60
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Rating
                    RatingStars(rating: place.rating, size: 14),
                  ],
                ),
              ),
            ),

            // Arrow
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              margin: const EdgeInsets.only(right: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
