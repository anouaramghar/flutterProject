import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/place_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_styles.dart';
import 'widgets/place_card.dart';
import 'widgets/search_bat.dart' as custom;
import 'widgets/category_filter.dart';
import '../details/place_details_page.dart';
import '../favorites/favorites_page.dart';
import '../maps/map_page.dart';

enum ViewMode { cards, grid, list }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  ViewMode _viewMode = ViewMode.cards;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load places and favorites on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadPlaces();
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  void _onCategorySelected(String? category) {
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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (provider.places.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Aucun lieu trouvé',
                  style: AppTextStyles.h4.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Essayez de modifier vos critères de recherche',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
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
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsPage(place: place),
                      ),
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
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailsPage(place: place),
                    ),
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
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailsPage(place: place),
                    ),
                  ),
                );
              },
            );
        }
      },
    );
  }

  Widget _buildHomeContent() {
    return Column(
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
              _buildViewModeButton(ViewMode.cards, Icons.view_agenda_outlined),
              _buildViewModeButton(ViewMode.grid, Icons.grid_view_outlined),
              _buildViewModeButton(ViewMode.list, Icons.view_list_outlined),
            ],
          ),
        ),

        // Places list
        Expanded(child: _buildPlacesList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore, color: AppColors.primary, size: 28),
            const SizedBox(width: AppSpacing.sm),
            const Text('Travel Guide Maroc'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildHomeContent(), const MapPage()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Carte',
            ),
          ],
        ),
      ),
    );
  }
}
