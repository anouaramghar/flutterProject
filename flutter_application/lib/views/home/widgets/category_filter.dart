import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';

class CategoryFilter extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Monument', 'icon': Icons.account_balance},
    {'name': 'Plage', 'icon': Icons.beach_access},
    {'name': 'Nature', 'icon': Icons.park},
    {'name': 'Médina', 'icon': Icons.location_city},
    {'name': 'Musée', 'icon': Icons.museum},
    {'name': 'Désert', 'icon': Icons.landscape},
    {'name': 'Montagne', 'icon': Icons.terrain},
    {'name': 'Jardin', 'icon': Icons.local_florist},
    {'name': 'Ville', 'icon': Icons.apartment},
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

          final category = categories[index - 1];
          final name = category['name'] as String;
          final icon = category['icon'] as IconData;

          return _buildChip(
            context,
            label: name,
            icon: icon,
            isSelected: selectedCategory == name,
            onTap: () => onCategorySelected(name),
            color: AppColors.getCategoryColor(name),
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
