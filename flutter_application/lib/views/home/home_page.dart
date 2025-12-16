import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/place_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_styles.dart';
import '../../models/place.dart';
import '../details/place_details_page.dart';
import '../favorites/favorites_page.dart';
import '../maps/map_page.dart';
import 'all_places_page.dart';
import '../../utils/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadPlaces();
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildLandingContent(), const MapPage()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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

  Widget _buildLandingContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(),

          // Description Section
          _buildDescriptionSection(),

          // Featured Places Section
          _buildFeaturedPlacesSection(),

          // "Voir Plus" Button
          _buildViewMoreButton(),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1531501410720-c8d437636169?w=1200',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        // Gradient overlay
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              stops: const [0.3, 1.0],
            ),
          ),
        ),

        // App Bar overlaid
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.explore, color: Colors.white, size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Travel Guide',
                      style: AppTextStyles.h4.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    buildFadeSlideRoute(const FavoritesPage()),
                  ),
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                ),
              ],
            ),
          ),
        ),

        // Hero Content
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'Explorez le Maroc',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Conseils de voyage\nMaroc',
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tous nos conseils pour préparer votre voyage au Maroc',
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Découvrez notre guide de voyage au Maroc. Du désert du Sahara aux paysages '
            'contrastés des montagnes de l\'Atlas, en passant par les villes impériales '
            'et les plages exceptionnelles de la côte atlantique, vous plongerez à corps '
            'perdu au cœur du Maroc.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Divider with icon
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Icon(
                  Icons.landscape,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section title
          Center(
            child: Text(
              'Que faire au Maroc ?',
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              'Découvrez les merveilles incontournables du royaume',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPlacesSection() {
    return Consumer<PlaceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          // Skeleton grid while loading
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.85,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildFeaturedSkeletonCard();
              },
            ),
          );
        }

        // Get first 6 places for featured section
        final featuredPlaces = provider.places.take(6).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
            ),
            itemCount: featuredPlaces.length,
            itemBuilder: (context, index) {
              final place = featuredPlaces[index];
              return _buildFeaturedCard(place);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedCard(Place place) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        buildFadeSlideRoute(PlaceDetailsPage(place: place)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.medium,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: place.images.isNotEmpty
                    ? place.images.first
                    : 'https://via.placeholder.com/300',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  child: const Icon(Icons.image, color: AppColors.textMuted),
                ),
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // Rating badge
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: AppColors.ratingStar,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title and city
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.secondaryLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          place.city,
                          style: AppTextStyles.labelSmall.copyWith(
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
      ),
    );
  }

  // Simple skeleton placeholder for featured cards
  Widget _buildFeaturedSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.secondary.withValues(alpha: 0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.3),
                    AppColors.secondaryDark.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 10,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
              buildFadeSlideRoute(const AllPlacesPage()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'VOIR TOUS LES LIEUX',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
