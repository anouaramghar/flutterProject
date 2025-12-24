import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/place_provider.dart';
import '../../models/place.dart';
import '../../utils/app_styles.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';
import '../../utils/navigation.dart';
import 'widgets/place_card.dart';
import 'widgets/search_bat.dart' as custom;
import 'widgets/category_filter.dart';
import '../details/place_details_page.dart';

enum ViewMode { cards, grid, list }

class AllPlacesPage extends StatefulWidget {
  const AllPlacesPage({super.key});

  @override
  State<AllPlacesPage> createState() => _AllPlacesPageState();
}

class _AllPlacesPageState extends State<AllPlacesPage> {
  ViewMode _viewMode = ViewMode.cards;
  PlaceCategory? _selectedCategory;

  void _onCategorySelected(PlaceCategory? category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == null) {
      context.read<PlaceProvider>().resetFilters();
    } else {
      context.read<PlaceProvider>().filterByCategory(category);
    }
  }

  void _onSearch(String query) {
    context.read<PlaceProvider>().searchByName(query);
  }

  Widget _buildViewModeButton(ViewMode mode, IconData icon, bool isDark) {
    final isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.white54 : AppColors.textMuted),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPlacesList(bool isDark) {
    return Consumer<PlaceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: const ShimmerListItem(),
              );
            },
          );
        }

        if (provider.places.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Aucun lieu trouvé',
            message: 'Essayez de modifier vos critères de recherche',
          ).animate().fadeIn(duration: 400.ms).scale();
        }

        switch (_viewMode) {
          case ViewMode.cards:
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: provider.places.length,
              itemBuilder: (context, index) {
                final place = provider.places[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child:
                      PlaceCard(
                            place: place,
                            viewMode: _viewMode,
                            onTap: () => Navigator.push(
                              context,
                              buildFadeSlideRoute(
                                PlaceDetailsPage(place: place),
                              ),
                            ),
                          )
                          .animate(delay: (index * 50).ms)
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: 0.1),
                );
              },
            );

          case ViewMode.grid:
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.75,
              ),
              itemCount: provider.places.length,
              itemBuilder: (context, index) {
                final place = provider.places[index];
                return PlaceCard(
                      place: place,
                      viewMode: _viewMode,
                      onTap: () => Navigator.push(
                        context,
                        buildFadeSlideRoute(PlaceDetailsPage(place: place)),
                      ),
                    )
                    .animate(delay: (index * 50).ms)
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.95, 0.95));
              },
            );

          case ViewMode.list:
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: provider.places.length,
              itemBuilder: (context, index) {
                final place = provider.places[index];
                return PlaceCard(
                      place: place,
                      viewMode: _viewMode,
                      onTap: () => Navigator.push(
                        context,
                        buildFadeSlideRoute(PlaceDetailsPage(place: place)),
                      ),
                    )
                    .animate(delay: (index * 40).ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.05);
              },
            );
        }
      },
    );
  }

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
              _buildCustomAppBar(
                isDark,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: custom.SearchBar(onSearch: _onSearch),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

              // Category filter
              CategoryFilter(
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

              // View mode toggle and results count
              _buildFilterBar(
                isDark,
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              // Places list
              Expanded(child: _buildPlacesList(isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(bool isDark) {
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

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Découvrir',
                  style: AppTextStyles.h3.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Explorez tous les lieux',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? Colors.white60 : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Sort button
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: isDark ? null : AppShadows.subtle,
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: isDark ? null : AppShadows.subtle,
        ),
        child: Row(
          children: [
            Consumer<PlaceProvider>(
              builder: (context, provider, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '${provider.places.length} lieux',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            _buildViewModeButton(
              ViewMode.cards,
              Icons.view_agenda_rounded,
              isDark,
            ),
            _buildViewModeButton(
              ViewMode.grid,
              Icons.grid_view_rounded,
              isDark,
            ),
            _buildViewModeButton(
              ViewMode.list,
              Icons.view_list_rounded,
              isDark,
            ),
          ],
        ),
      ),
    );
  }
}
