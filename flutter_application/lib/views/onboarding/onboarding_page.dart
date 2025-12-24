import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_styles.dart';
import '../home/home_page.dart';

/// Model for onboarding slide data
class OnboardingSlide {
  final String title;
  final String subtitle;
  final String description;
  final String imageAsset;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageAsset,
    required this.icon,
    required this.gradientColors,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _buttonController;

  // Onboarding slides data
  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Bienvenue',
      subtitle: 'Travel Guide Maroc',
      description:
          'Découvrez les merveilles du Maroc, des médinas ancestrales aux paysages époustouflants du Sahara.',
      imageAsset: 'assets/images/home_image.jpg',
      icon: Icons.explore_rounded,
      gradientColors: [Color(0xFFD45B35), Color(0xFFFF8A65)],
    ),
    OnboardingSlide(
      title: 'Explorez',
      subtitle: 'Des lieux uniques',
      description:
          'Parcourez des centaines de lieux touristiques, des monuments historiques aux plages paradisiaques.',
      imageAsset: 'assets/images/todgha_gorges.jpg',
      icon: Icons.location_on_rounded,
      gradientColors: [Color(0xFF7C5CE0), Color(0xFFA78BFA)],
    ),
    OnboardingSlide(
      title: 'Planifiez',
      subtitle: 'Vos itinéraires',
      description:
          'Créez vos propres circuits, sauvegardez vos favoris et naviguez avec la carte interactive.',
      imageAsset: 'assets/images/home_image.jpg',
      icon: Icons.route_rounded,
      gradientColors: [Color(0xFF26C6DA), Color(0xFF4DD0E1)],
    ),
    OnboardingSlide(
      title: 'Prêt ?',
      subtitle: 'Commencez l\'aventure',
      description:
          'Votre voyage au Maroc commence maintenant. Laissez-vous guider par notre application.',
      imageAsset: 'assets/images/todgha_gorges.jpg',
      icon: Icons.rocket_launch_rounded,
      gradientColors: [Color(0xFF66BB6A), Color(0xFF81C784)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // Page View
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                if (index == _slides.length - 1) {
                  _buttonController.forward();
                } else {
                  _buttonController.reverse();
                }
              },
              itemBuilder: (context, index) {
                return _buildSlide(_slides[index], index);
              },
            ),

            // Skip Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 20,
              child: AnimatedOpacity(
                opacity: _currentPage < _slides.length - 1 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  child: Text(
                    'Passer',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            ),

            // Bottom Section
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          slide.imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: slide.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                slide.gradientColors[0].withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.5),
                Colors.black.withValues(alpha: 0.9),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),

                // Animated Icon
                _buildAnimatedIcon(slide, index),
                const SizedBox(height: 24),

                // Title Badge
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: slide.gradientColors),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: slide.gradientColors[0].withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        slide.title.toUpperCase(),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                    .animate(key: ValueKey('badge_$index'), delay: 200.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.2),

                const SizedBox(height: 20),

                // Subtitle
                Text(
                      slide.subtitle,
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 36,
                        height: 1.1,
                      ),
                    )
                    .animate(key: ValueKey('subtitle_$index'), delay: 300.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2),

                const SizedBox(height: 16),

                // Description
                Text(
                      slide.description,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.6,
                      ),
                    )
                    .animate(key: ValueKey('desc_$index'), delay: 400.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2),

                const SizedBox(height: 160),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedIcon(OnboardingSlide slide, int index) {
    return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: slide.gradientColors),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: slide.gradientColors[0].withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(slide.icon, color: Colors.white, size: 40),
        )
        .animate(key: ValueKey('icon_$index'), delay: 100.ms)
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.5, 0.5));
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        32,
        24,
        32,
        MediaQuery.of(context).padding.bottom + 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page Indicators
          _buildPageIndicators(),
          const SizedBox(height: 32),

          // Next/Start Button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final isActive = index == _currentPage;
        final slide = _slides[index];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(colors: slide.gradientColors)
                : null,
            color: isActive ? null : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.full),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: slide.gradientColors[0].withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentPage == _slides.length - 1;
    final currentSlide = _slides[_currentPage];

    return GestureDetector(
      onTap: _nextPage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isLastPage ? double.infinity : 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: currentSlide.gradientColors),
          borderRadius: BorderRadius.circular(isLastPage ? AppRadius.full : 32),
          boxShadow: [
            BoxShadow(
              color: currentSlide.gradientColors[0].withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLastPage
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Commencer l\'aventure',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                )
              : const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 28,
                ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideY(begin: 0.3);
  }
}

/// Check if onboarding has been completed
Future<bool> hasCompletedOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_completed') ?? false;
}

/// Reset onboarding (for testing)
Future<void> resetOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('onboarding_completed');
}
