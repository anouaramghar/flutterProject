import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/place_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_styles.dart';
import '../../models/place.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/modern_components.dart';
import '../details/place_details_page.dart';
import '../favorites/favorites_page.dart';
import '../maps/map_page.dart';
import 'all_places_page.dart';
import '../../utils/navigation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../details/article_page.dart';
import 'package:latlong2/latlong.dart';
import '../../models/travel_route.dart';
import '../details/route_details_page.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadPlaces();
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _currentIndex == 0
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: [_buildLandingContent(), const MapPage()],
        ),
        bottomNavigationBar: _buildModernBottomNav(),
      ),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Accueil',
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map_rounded,
              label: 'Carte',
              index: 1,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3);
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 24 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLandingContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(),

          // Description Section
          _buildDescriptionSection()
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.1),

          // Featured Places Section
          _buildFeaturedPlacesSection().animate().fadeIn(
            duration: 500.ms,
            delay: 300.ms,
          ),

          // "Voir Plus" Button
          _buildViewMoreButton()
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideY(begin: 0.1),

          // Article Section
          _buildArticleSection()
              .animate()
              .fadeIn(duration: 500.ms, delay: 500.ms)
              .slideX(begin: 0.1),

          const SizedBox(height: AppSpacing.xl),

          // Routes Section
          _buildRoutesSection().animate().fadeIn(
            duration: 500.ms,
            delay: 600.ms,
          ),

          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Background Image with parallax effect
        Container(
          height: 420,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/home_image.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.2),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        // Gradient overlay with modern curve
        Container(
          height: 420,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Bottom curve
        Positioned(
          bottom: -2,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        ),

        // App Bar overlaid
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppShadows.coloredShadow(AppColors.primary),
                      ),
                      child: const Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Travel Guide',
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2),
                Row(
                  children: [
                    GlassIconButton(
                      icon: Icons.favorite_border_rounded,
                      onPressed: () => Navigator.push(
                        context,
                        buildFadeSlideRoute(const FavoritesPage()),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GlassIconButton(
                      icon: Icons.settings_rounded,
                      onPressed: () => Navigator.push(
                        context,
                        buildFadeSlideRoute(const SettingsPage()),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2),
              ],
            ),
          ),
        ),

        // Hero Content
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.coloredShadow(AppColors.primary),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Explorez le Maroc',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.3),
              const SizedBox(height: AppSpacing.md),
              Text(
                    'Votre Guide\nde Voyage',
                    style: AppTextStyles.displayLarge.copyWith(
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2),
              const SizedBox(height: AppSpacing.sm),
              Text(
                    'Découvrez les merveilles du royaume',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcoming text
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.subtle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Conseils de Voyage',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Du désert du Sahara aux paysages contrastés des montagnes de l\'Atlas, '
                  'en passant par les villes impériales et les plages exceptionnelles '
                  'de la côte atlantique.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Section title with icon
          SectionHeader(
            title: 'Que faire au Maroc ?',
            subtitle: 'Découvrez les merveilles incontournables',
            icon: Icons.location_on_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPlacesSection() {
    return Consumer<PlaceProvider>(
      builder: (context, provider, _) {
        // Loading state with shimmer
        if (provider.isLoading) {
          return SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  child: const ShimmerFeaturedCard(),
                );
              },
            ),
          );
        }

        final featuredPlaces = provider.places.take(6).toList();

        // Modern Carousel
        return CarouselSlider.builder(
          itemCount: featuredPlaces.length,
          itemBuilder: (context, index, realIndex) {
            final place = featuredPlaces[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: _buildModernFeaturedCard(place)
                  .animate(delay: (index * 100).ms)
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.95, 0.95)),
            );
          },
          options: CarouselOptions(
            height: 260.0,
            viewportFraction: 0.48,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            autoPlayCurve: Curves.easeInOutCubic,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }

  Widget _buildModernFeaturedCard(Place place) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        buildFadeSlideRoute(PlaceDetailsPage(place: place)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.large,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with hero animation ready
              Hero(
                tag: 'place_image_${place.id}',
                child: CachedNetworkImage(
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
              ),

              // Modern gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              ),

              // Rating badge with glass effect
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: GlassDarkContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  borderRadius: AppRadius.full,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.ratingStar,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category badge
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.getCategoryColorFromEnum(place.category),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    placeCategoryToDisplayString(place.category),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
                      style: AppTextStyles.cardTitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppColors.secondaryLight,
                        ),
                        const SizedBox(width: 4),
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

  Widget _buildViewMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: GradientButton(
          text: 'VOIR TOUS LES LIEUX',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => Navigator.push(
            context,
            buildFadeSlideRoute(const AllPlacesPage()),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ArticlePage()),
        );
      },
      child: Container(
        height: 280,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          boxShadow: AppShadows.coloredShadow(AppColors.primary),
          image: const DecorationImage(
            image: AssetImage('assets/images/todgha_gorges.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.3, 0.5, 1.0],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      boxShadow: AppShadows.glow(AppColors.primary),
                    ),
                    child: const Text(
                      'GUIDE DE VOYAGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Title
                  Text(
                    'Où partir au Maroc ?',
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Subtitle
                  Text(
                    'Des montagnes de l\'Atlas aux dunes du Sahara, découvrez les régions qui font rêver.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Read more button
                  Row(
                    children: [
                      Text(
                        'Lire l\'article',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
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

  Widget _buildRoutesSection() {
    final List<TravelRoute> routes = [
      TravelRoute(
        title: "Le Grand Sud",
        duration: "4 Jours",
        coverImage:
            "https://images.unsplash.com/photo-1548588627-f978862b85e1?w=800",
        stations: [
          RouteStation(
            name: "Marrakech",
            image:
                "https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=400",
            coordinate: const LatLng(31.6295, -7.9811),
            description: "Point de départ, la ville rouge et ses souks.",
          ),
          RouteStation(
            name: "Aït Ben Haddou",
            image:
                "https://images.unsplash.com/photo-1576014131795-d440191a8e8b?w=400",
            coordinate: const LatLng(31.0470, -7.1319),
            description: "Ksar historique classé à l'UNESCO.",
          ),
          RouteStation(
            name: "Ouarzazate",
            image:
                "https://images.unsplash.com/photo-1539020140153-e479b8c22e70?w=400",
            coordinate: const LatLng(30.9189, -6.9196),
            description: "La porte du désert et ses studios de cinéma.",
          ),
        ],
      ),
      TravelRoute(
        title: "Route Côtière",
        duration: "3 Jours",
        coverImage:
            "https://images.unsplash.com/photo-1580618055006-039c0490eb7e?w=800",
        stations: [
          RouteStation(
            name: "Essaouira",
            image:
                "https://images.unsplash.com/photo-1575883398906-8b29c0a52f9b?w=400",
            coordinate: const LatLng(31.5085, -9.7595),
            description: "La cité des vents et ses remparts bleus.",
          ),
          RouteStation(
            name: "Agadir",
            image:
                "https://images.unsplash.com/photo-1565532386869-7c4856033873?w=400",
            coordinate: const LatLng(30.4278, -9.5981),
            description: "Plages immenses et soleil toute l'année.",
          ),
          RouteStation(
            name: "Taghazout",
            image:
                "https://images.unsplash.com/photo-1532960401447-7dd05bef20b0?w=400",
            coordinate: const LatLng(30.5449, -9.7091),
            description: "Le paradis des surfeurs et des couchers de soleil.",
          ),
        ],
      ),
      TravelRoute(
        title: "Perles du Nord",
        duration: "5 Jours",
        coverImage:
            "https://images.unsplash.com/photo-1564507004663-b6dfb3c824d5?w=800",
        stations: [
          RouteStation(
            name: "Tanger",
            image:
                "https://images.unsplash.com/photo-1587595431973-160d0d94add1?w=400",
            coordinate: const LatLng(35.7595, -5.8340),
            description: "La ville blanche face à l'Europe.",
          ),
          RouteStation(
            name: "Chefchaouen",
            image:
                "https://images.unsplash.com/photo-1518182170546-0766ce6fec56?w=400",
            coordinate: const LatLng(35.1716, -5.2697),
            description: "La célèbre perle bleue dans les montagnes.",
          ),
          RouteStation(
            name: "Akchour",
            image:
                "https://images.unsplash.com/photo-1667852627916-16f55694c256?w=400",
            coordinate: const LatLng(35.2369, -5.1456),
            description: "Cascades cristallines et randonnées.",
          ),
        ],
      ),
      TravelRoute(
        title: "Impérial",
        duration: "6 Jours",
        coverImage:
            "https://images.unsplash.com/photo-1535201104882-7d22b622f980?w=800",
        stations: [
          RouteStation(
            name: "Fès",
            image:
                "https://images.unsplash.com/photo-1557754388-c7a6e1233840?w=400",
            coordinate: const LatLng(34.0181, -5.0078),
            description: "La capitale spirituelle et sa médina millénaire.",
          ),
          RouteStation(
            name: "Meknès",
            image:
                "https://images.unsplash.com/photo-1571409249764-169826d97c36?w=400",
            coordinate: const LatLng(33.8938, -5.5516),
            description: "La ville aux cent minarets et Bab Mansour.",
          ),
          RouteStation(
            name: "Volubilis",
            image:
                "https://images.unsplash.com/photo-1596530663737-293630f9d936?w=400",
            coordinate: const LatLng(34.0725, -5.5538),
            description: "Ruines romaines exceptionnellement préservées.",
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Itinéraires Populaires',
          subtitle: 'Des circuits prêts à l\'emploi',
          icon: Icons.route_rounded,
          actionText: 'Voir tout',
          onActionTap: () {
            // Navigate to all routes
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 220,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return _buildModernRouteCard(route, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernRouteCard(TravelRoute route, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RouteDetailsPage(route: route)),
        );
      },
      child:
          Container(
                width: 300,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: AppShadows.medium,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(route.coverImage),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.15),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Duration badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  route.duration,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Title
                          Text(
                            route.title,
                            style: AppTextStyles.h4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          // Stations preview
                          Row(
                            children: [
                              Icon(
                                Icons.place_rounded,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  route.stations.map((s) => s.name).join(' → '),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (index * 100).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.1),
    );
  }
}
