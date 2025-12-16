import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/place.dart';
import '../../../utils/app_styles.dart';
import '../../../widgets/rating_stars.dart';
import '../all_places_page.dart';

class PlaceCard extends StatefulWidget {
  final Place place;
  final ViewMode viewMode;
  final VoidCallback? onTap;

  const PlaceCard({
    super.key,
    required this.place,
    required this.viewMode,
    this.onTap,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (widget.viewMode) {
      case ViewMode.cards:
        child = _buildCardView();
        break;
      case ViewMode.grid:
        child = _buildGridView();
        break;
      case ViewMode.list:
        child = _buildListView();
        break;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: child,
        ),
      ),
    );
  }

  // Card View - Large image with overlay info
  Widget _buildCardView() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            _buildImage(),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),

            // Category badge
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: _buildCategoryBadge(),
            ),

            // Rating
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: _buildRatingBadge(),
            ),

            // Info at bottom
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.place.name,
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.secondaryLight,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        widget.place.city,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid View - Square cards with compact info
  Widget _buildGridView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildImage(),
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: _buildRatingBadge(compact: true),
                ),
              ],
            ),
          ),

          // Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.place.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          widget.place.city,
                          style: AppTextStyles.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildCategoryBadge(compact: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // List View - Horizontal compact row
  Widget _buildListView() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox(width: 80, height: 80, child: _buildImage()),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.place.name,
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
                    Text(
                      widget.place.city,
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _buildCategoryBadge(compact: true),
                    const Spacer(),
                    RatingStars(rating: widget.place.rating, size: 14),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (widget.place.images.isEmpty) {
      return Container(
        color: AppColors.secondary.withOpacity(0.3),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textMuted,
            size: 40,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.place.images.first,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.secondary.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.secondary.withOpacity(0.3),
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.textMuted,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge({bool compact = false}) {
    final color = AppColors.getCategoryColorFromEnum(widget.place.category);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: compact ? color.withOpacity(0.15) : color,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        placeCategoryToDisplayString(widget.place.category),
        style: (compact ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
            .copyWith(
              color: compact ? color : Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildRatingBadge({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: compact ? 12 : 14,
            color: AppColors.ratingStar,
          ),
          const SizedBox(width: 2),
          Text(
            widget.place.rating.toStringAsFixed(1),
            style:
                (compact ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
