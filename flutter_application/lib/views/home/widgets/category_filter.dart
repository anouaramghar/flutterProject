import 'package:flutter/material.dart';
import '../../../models/place.dart';
import '../../../utils/app_styles.dart';

class CategoryFilter extends StatelessWidget {
  final PlaceCategory? selectedCategory;
  final Function(PlaceCategory?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _buildCategoryChip(
            label: 'Tout',
            icon: Icons.apps_rounded,
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
            color: AppColors.primary,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.monument),
            icon: Icons.account_balance_rounded,
            isSelected: selectedCategory == PlaceCategory.monument,
            onTap: () => onCategorySelected(PlaceCategory.monument),
            color: AppColors.monument,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.plage),
            icon: Icons.beach_access_rounded,
            isSelected: selectedCategory == PlaceCategory.plage,
            onTap: () => onCategorySelected(PlaceCategory.plage),
            color: AppColors.plage,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.nature),
            icon: Icons.park_rounded,
            isSelected: selectedCategory == PlaceCategory.nature,
            onTap: () => onCategorySelected(PlaceCategory.nature),
            color: AppColors.nature,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.medina),
            icon: Icons.location_city_rounded,
            isSelected: selectedCategory == PlaceCategory.medina,
            onTap: () => onCategorySelected(PlaceCategory.medina),
            color: AppColors.medina,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.musee),
            icon: Icons.museum_rounded,
            isSelected: selectedCategory == PlaceCategory.musee,
            onTap: () => onCategorySelected(PlaceCategory.musee),
            color: AppColors.musee,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.desert),
            icon: Icons.terrain_rounded,
            isSelected: selectedCategory == PlaceCategory.desert,
            onTap: () => onCategorySelected(PlaceCategory.desert),
            color: AppColors.desert,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.montagne),
            icon: Icons.landscape_rounded,
            isSelected: selectedCategory == PlaceCategory.montagne,
            onTap: () => onCategorySelected(PlaceCategory.montagne),
            color: AppColors.montagne,
          ),
          _buildCategoryChip(
            label: placeCategoryToDisplayString(PlaceCategory.jardin),
            icon: Icons.local_florist_rounded,
            isSelected: selectedCategory == PlaceCategory.jardin,
            onTap: () => onCategorySelected(PlaceCategory.jardin),
            color: AppColors.jardin,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppSpacing.md : AppSpacing.sm + 4,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.85)])
              : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.subtle,
          border: isSelected
              ? null
              : Border.all(color: AppColors.textMuted.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isSelected ? 0 : 4),
              decoration: isSelected
                  ? null
                  : BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
              child: Icon(
                icon,
                size: isSelected ? 18 : 14,
                color: isSelected ? Colors.white : color,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
