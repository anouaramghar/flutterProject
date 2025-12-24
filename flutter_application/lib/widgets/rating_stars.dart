import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;
  final Color? activeColor;
  final Color? inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.showValue = false,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeStarColor = activeColor ?? AppColors.ratingStar;
    final inactiveStarColor =
        inactiveColor ?? AppColors.ratingEmpty.withValues(alpha: 0.5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final difference = rating - index;
          IconData icon;
          Color color;

          if (difference >= 1) {
            icon = Icons.star_rounded;
            color = activeStarColor;
          } else if (difference > 0) {
            icon = Icons.star_half_rounded;
            color = activeStarColor;
          } else {
            icon = Icons.star_outline_rounded;
            color = inactiveStarColor;
          }

          return Padding(
            padding: EdgeInsets.only(right: index < 4 ? 2 : 0),
            child: Icon(icon, size: size, color: color),
          );
        }),
        if (showValue) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact rating display with a single star and value
class RatingBadge extends StatelessWidget {
  final double rating;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const RatingBadge({
    super.key,
    required this.rating,
    this.size = 12,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: size, color: AppColors.ratingStar),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
