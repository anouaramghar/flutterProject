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
import 'package:carousel_slider/carousel_slider.dart';
import '../details/article_page.dart';
import 'package:latlong2/latlong.dart';
import '../../models/travel_route.dart';
import '../details/route_details_page.dart';

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

          // Article Section
          _buildArticleSection(),
          
          const SizedBox(height: AppSpacing.xl),
          _buildRoutesSection(),

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
              image: const AssetImage('assets/images/home_image.jpg'),
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
        // 1. État de chargement (Squelette horizontal)
        if (provider.isLoading) {
          return SizedBox(
            height: 220, // Hauteur fixe pour le conteneur de chargement
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: 160, // Largeur fixe pour l'effet "petite taille"
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  child: _buildFeaturedSkeletonCard(),
                );
              },
            ),
          );
        }

        // Récupérer les 6 premiers lieux
        final featuredPlaces = provider.places.take(6).toList();

        // 2. Le Carrousel Automatique
        return CarouselSlider.builder(
          itemCount: featuredPlaces.length,
          itemBuilder: (context, index, realIndex) {
            final place = featuredPlaces[index];
            // On enveloppe la card dans un container pour gérer les marges internes du carrousel
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: _buildFeaturedCard(place),
            );
          },
          options: CarouselOptions(
            height: 220.0, // Hauteur réduite pour des cartes "petite taille"
            
            // viewportFraction gère la largeur des cartes. 
            // 0.45 signifie que la carte prend 45% de la largeur de l'écran (donc petite).
            viewportFraction: 0.45, 
            
            enableInfiniteScroll: true, // Défilement infini
            autoPlay: true, // Défilement automatique activé
            autoPlayInterval: const Duration(seconds: 3), // Vitesse du défilement
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true, // Met légèrement en avant la carte centrale (optionnel)
            enlargeFactor: 0.15, // Intensité de l'agrandissement central
            scrollDirection: Axis.horizontal,
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

  Widget _buildArticleSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ArticlePage()),
        );
      },
      child: Container(
        height: 260, // On donne de la hauteur pour l'impact visuel
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Coins très arrondis
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4), // Ombre colorée
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/images/todgha_gorges.jpg'), 
            fit: BoxFit.cover,
            ),
        ),
        child: Stack(
          children: [
            // 1. Le Dégradé (pour que le texte soit lisible)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),

            // 2. Le Contenu Texte + Badge
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Badge "Inspiration"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(height: 12),

                  // Grand Titre
                  const Text(
                    'Où partir au Maroc ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sous-titre descriptif
                  Text(
                    'Des montagnes de l\'Atlas aux dunes du Sahara, découvrez les régions qui font rêver.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // Bouton "Lire la suite" stylisé
                  Row(
                    children: [
                      const Text(
                        'Lire l\'article',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
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
    // Liste enrichie avec 4 trajets
    final List<TravelRoute> routes = [
      // TRAJET 1 : LE SUD
      TravelRoute(
        title: "Le Grand Sud",
        duration: "4 Jours",
        coverImage: "https://images.unsplash.com/photo-1548588627-f978862b85e1?w=800",
        stations: [
          RouteStation(
            name: "Marrakech",
            image: "https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=400",
            coordinate: const LatLng(31.6295, -7.9811),
            description: "Point de départ, la ville rouge et ses souks.",
          ),
          RouteStation(
            name: "Aït Ben Haddou",
            image: "https://images.unsplash.com/photo-1576014131795-d440191a8e8b?w=400",
            coordinate: const LatLng(31.0470, -7.1319),
            description: "Ksar historique classé à l'UNESCO.",
          ),
          RouteStation(
            name: "Ouarzazate",
            image: "https://images.unsplash.com/photo-1539020140153-e479b8c22e70?w=400",
            coordinate: const LatLng(30.9189, -6.9196),
            description: "La porte du désert et ses studios de cinéma.",
          ),
        ],
      ),

      // TRAJET 2 : LA CÔTE
      TravelRoute(
        title: "Route Côtière",
        duration: "3 Jours",
        coverImage: "https://images.unsplash.com/photo-1580618055006-039c0490eb7e?w=800",
        stations: [
           RouteStation(
            name: "Essaouira",
            image: "https://images.unsplash.com/photo-1575883398906-8b29c0a52f9b?w=400",
            coordinate: const LatLng(31.5085, -9.7595),
            description: "La cité des vents et ses remparts bleus.",
          ),
           RouteStation(
            name: "Agadir",
            image: "https://images.unsplash.com/photo-1565532386869-7c4856033873?w=400",
            coordinate: const LatLng(30.4278, -9.5981),
            description: "Plages immenses et soleil toute l'année.",
          ),
           RouteStation(
            name: "Taghazout",
            image: "https://images.unsplash.com/photo-1532960401447-7dd05bef20b0?w=400",
            coordinate: const LatLng(30.5449, -9.7091),
            description: "Le paradis des surfeurs et des couchers de soleil.",
          ),
        ],
      ),

      // TRAJET 3 : LE NORD (Nouveau)
      TravelRoute(
        title: "Perles du Nord",
        duration: "5 Jours",
        coverImage: "https://images.unsplash.com/photo-1564507004663-b6dfb3c824d5?w=800", // Chefchaouen
        stations: [
          RouteStation(
            name: "Tanger",
            image: "https://images.unsplash.com/photo-1587595431973-160d0d94add1?w=400",
            coordinate: const LatLng(35.7595, -5.8340),
            description: "La ville blanche face à l'Europe.",
          ),
          RouteStation(
            name: "Chefchaouen",
            image: "https://images.unsplash.com/photo-1518182170546-0766ce6fec56?w=400",
            coordinate: const LatLng(35.1716, -5.2697),
            description: "La célèbre perle bleue dans les montagnes.",
          ),
          RouteStation(
            name: "Akchour",
            image: "https://images.unsplash.com/photo-1667852627916-16f55694c256?w=400",
            coordinate: const LatLng(35.2369, -5.1456),
            description: "Cascades cristallines et randonnées.",
          ),
        ],
      ),

      // TRAJET 4 : VILLES IMPÉRIALES (Nouveau)
      TravelRoute(
        title: "Impérial",
        duration: "6 Jours",
        coverImage: "https://images.unsplash.com/photo-1535201104882-7d22b622f980?w=800", // Fes
        stations: [
          RouteStation(
            name: "Fès",
            image: "https://images.unsplash.com/photo-1557754388-c7a6e1233840?w=400",
            coordinate: const LatLng(34.0181, -5.0078),
            description: "La capitale spirituelle et sa médina millénaire.",
          ),
          RouteStation(
            name: "Meknès",
            image: "https://images.unsplash.com/photo-1571409249764-169826d97c36?w=400",
            coordinate: const LatLng(33.8938, -5.5516),
            description: "La ville aux cent minarets et Bab Mansour.",
          ),
          RouteStation(
            name: "Volubilis",
            image: "https://images.unsplash.com/photo-1596530663737-293630f9d936?w=400",
            coordinate: const LatLng(34.0725, -5.5538),
            description: "Ruines romaines exceptionnellement préservées.",
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Itinéraires Populaires',
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RouteDetailsPage(route: route),
                    ),
                  );
                },
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(route.coverImage),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Dégradé pour le texte
                      Container(
                        decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(AppRadius.lg),
                           gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                            stops: const [0.6, 1.0],
                           )
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                route.duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              route.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
