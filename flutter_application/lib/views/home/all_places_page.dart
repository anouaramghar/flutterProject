import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/place_provider.dart';
import '../../models/place.dart';
import '../../utils/app_styles.dart';
import '../../widgets/empty_state.dart';
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

  Widget _buildViewModeButton(ViewMode mode, IconData icon) {
    final isSelected = _viewMode == mode;
    return IconButton(
      onPressed: () => setState(() => _viewMode = mode),
      icon: Icon(icon),
      color: isSelected ? AppColors.primary : AppColors.textMuted,
      iconSize: 22,
    );
  }

  Widget _buildPlacesList() {
    return Consumer<PlaceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          // Skeleton list while loading
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _buildSkeletonListItem(),
              );
            },
          );
        }

        if (provider.places.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Aucun lieu trouvé',
            message: 'Essayez de modifier vos critères de recherche',
          );
        }

        switch (_viewMode) {
          case ViewMode.cards:
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: provider.places.length,
              itemBuilder: (context, index) {
                final place = provider.places[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PlaceCard(
                    place: place,
                    viewMode: _viewMode,
                    onTap: () => Navigator.push(
                      context,
                      buildFadeSlideRoute(PlaceDetailsPage(place: place)),
                    ),
                  ),
                );
              },
            );

          case ViewMode.grid:
            return GridView.builder(
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
                );
              },
            );

          case ViewMode.list:
            return ListView.builder(
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
                );
              },
            );
        }
      },
    );
  }

  Widget _buildSkeletonListItem() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          // Thumbnail skeleton
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Text skeletons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 10,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les lieux'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: custom.SearchBar(onSearch: _onSearch),
          ),

          // Category filter
          CategoryFilter(
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),

          // View mode toggle and results count
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Consumer<PlaceProvider>(
                  builder: (context, provider, _) {
                    return Text(
                      '${provider.places.length} lieux',
                      style: AppTextStyles.labelMedium,
                    );
                  },
                ),
                const Spacer(),
                _buildViewModeButton(
                  ViewMode.cards,
                  Icons.view_agenda_outlined,
                ),
                _buildViewModeButton(ViewMode.grid, Icons.grid_view_outlined),
                _buildViewModeButton(ViewMode.list, Icons.view_list_outlined),
              ],
            ),
          ),

          // Places list
          Expanded(child: _buildPlacesList()),
        ],
      ),
    );
  }
}
