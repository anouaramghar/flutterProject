import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';
import '../../../models/place.dart';

class CategoryFilter extends StatelessWidget {
  final PlaceCategory? selectedCategory;
  final Function(PlaceCategory?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> categories = [
    {'category': PlaceCategory.monument, 'icon': Icons.account_balance},
    {'category': PlaceCategory.plage, 'icon': Icons.beach_access},
    {'category': PlaceCategory.nature, 'icon': Icons.park},
    {'category': PlaceCategory.medina, 'icon': Icons.location_city},
    {'category': PlaceCategory.musee, 'icon': Icons.museum},
    {'category': PlaceCategory.desert, 'icon': Icons.landscape},
    {'category': PlaceCategory.montagne, 'icon': Icons.terrain},
    {'category': PlaceCategory.jardin, 'icon': Icons.local_florist},
    {'category': PlaceCategory.ville, 'icon': Icons.apartment},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: categories.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            return _buildChip(
              context,
              label: 'Tous',
              icon: Icons.apps,
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            );
          }

          final config = categories[index - 1];
          final category = config['category'] as PlaceCategory;
          final icon = config['icon'] as IconData;
          final label = placeCategoryToDisplayString(category);

          return _buildChip(
            context,
            label: label,
            icon: icon,
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
            color: AppColors.getCategoryColorFromEnum(category),
          );
        },
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? chipColor : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: isSelected
                  ? chipColor
                  : AppColors.textMuted.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: isSelected ? AppShadows.small : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : chipColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
