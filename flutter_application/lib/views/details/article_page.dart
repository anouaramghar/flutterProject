import 'package:flutter/material.dart';
// Assurez-vous d'avoir ce package
import '../../utils/app_styles.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  static const List<Map<String, String>> _sections = [
    {
      'title': 'Marrakech et le sud',
      'content':
          'Marrakech est une ville fascinante qui mêle traditions et modernité. La médina, avec la place Jemaa el-Fna et ses souks animés, est un incontournable. Le palais de la Bahia, les jardins Majorelle et la médersa Ben Youssef sont des sites emblématiques à visiter.',
    },
    {
      'title': 'Fès et le nord',
      'content':
          'Fès est une ville chargée d’histoire avec l’une des médinas les mieux préservées du monde. La médersa Bou Inania et l’université Al Quaraouiyine sont des lieux incontournables. Plus au nord, Chefchaouen, la ville bleue, offre un cadre authentique.',
    },
    {
      'title': 'Casablanca & l\'Océan',
      'content':
          'Casablanca est une métropole moderne où se mêlent architecture coloniale et infrastructures contemporaines. La mosquée Hassan II est l’un des édifices les plus impressionnants du pays. La côte atlantique séduit par ses plages et son climat doux.',
    },
    {
      'title': 'Le Sahara Infini',
      'content':
          'Le Sahara marocain est une destination de rêve pour les amateurs de grands espaces. Les dunes de Merzouga et de Chegaga offrent des panoramas exceptionnels et des expériences inoubliables en bivouac sous les étoiles.',
    },
    {
      'title': 'L’Atlas et les Berbères',
      'content':
          'Le Haut Atlas est idéal pour la randonnée. Le mont Toubkal attire les passionnés de trekking. Les villages berbères comme Imlil offrent une immersion authentique dans la culture montagnarde marocaine.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. L'AppBar Élastique (Premium Header)
          _buildSliverAppBar(context),

          // 2. Le Contenu
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              40,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Intro et Titre
                _buildIntroHeader(),

                const SizedBox(height: AppSpacing.xl),
                const Divider(height: 1, color: Colors.black12),
                const SizedBox(height: AppSpacing.xl),

                // Les Sections
                ..._sections.asMap().entries.map((entry) {
                  return _buildSectionItem(
                    index: entry.key,
                    title: entry.value['title']!,
                    content: entry.value['content']!,
                    isLast: entry.key == _sections.length - 1,
                  );
                }),

                const SizedBox(height: AppSpacing.xl),
                _buildQualitiesSection(),

                // Footer Auteur
                const SizedBox(height: AppSpacing.xl),
                _buildAuthorFooter(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320.0, // Plus haut pour l'effet magazine
      backgroundColor: AppColors.primary,
      stretch: true, // Effet élastique au scroll
      pinned: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image de fond
            Image.asset('assets/images/banner_article.jpg', fit: BoxFit.cover),
            // Dégradé sombre pour le texte
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.5, 0.8, 1.0],
                ),
              ),
            ),
            // Titre sur l'image
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'GUIDE COMPLET',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Les Incontournables\ndu Maroc',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
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

  Widget _buildIntroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              '5 min de lecture',
              style: AppTextStyles.labelSmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(width: 20),
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              'Oct 2023',
              style: AppTextStyles.labelSmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          "Le Maroc est un pays de contrastes saisissants. Des montagnes enneigées de l'Atlas aux dunes dorées du Sahara, voici votre itinéraire idéal.",
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            height: 1.5,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Widget pour chaque section avec design "Timeline"
  Widget _buildSectionItem({
    required int index,
    required String title,
    required String content,
    required bool isLast,
  }) {
    // Format du numéro (01, 02...)
    final number = (index + 1).toString().padLeft(2, '0');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colonne de Gauche (Numéro + Ligne)
          Column(
            children: [
              Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),

          // Colonne de Droite (Contenu)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 20,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Écrit par',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.grey),
              ),
              const Text(
                'L\'équipe AMA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 1. La section globale des qualités
  Widget _buildQualitiesSection() {
    // Les données des qualités
    final List<Map<String, dynamic>> qualities = [
      {'icon': Icons.favorite, 'label': 'Hospitalité'},
      {'icon': Icons.restaurant_menu, 'label': 'Gastronomie'},
      {'icon': Icons.landscape, 'label': 'Paysages'},
      {'icon': Icons.history_edu, 'label': 'Patrimoine'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pourquoi le Maroc ?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05), // Fond très léger
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: qualities.map((q) {
              return _buildQualityItem(q['icon'], q['label']);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQualityItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
