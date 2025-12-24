import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD45B35), Color(0xFFB33F1E), Color(0xFF8B2F15)],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            _buildBackgroundDecorations(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  _buildAnimatedLogo(),
                  const SizedBox(height: 32),

                  // App Name
                  _buildAppName(),
                  const SizedBox(height: 8),

                  // Tagline
                  _buildTagline(),
                  const SizedBox(height: 48),

                  // Loading indicator
                  _buildLoadingIndicator(),
                ],
              ),
            ),

            // Bottom branding
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 0,
              right: 0,
              child: _buildBottomBranding(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Top right circle
        Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 3.seconds,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.1, 1.1),
              end: const Offset(1, 1),
              duration: 3.seconds,
              curve: Curves.easeInOut,
            ),

        // Bottom left circle
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
        ),

        // Middle floating circle
        Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 50,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat())
            .moveY(begin: 0, end: 20, duration: 2.seconds)
            .then()
            .moveY(begin: 20, end: 0, duration: 2.seconds),

        // Another floating element
        Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              right: 40,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat())
            .moveY(begin: 0, end: -15, duration: 2.5.seconds)
            .then()
            .moveY(begin: -15, end: 0, duration: 2.5.seconds),
      ],
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(
                      alpha: 0.2 + (_pulseController.value * 0.2),
                    ),
                    blurRadius: 30 + (_pulseController.value * 20),
                    spreadRadius: 5 + (_pulseController.value * 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.explore_rounded,
                size: 60,
                color: Color(0xFFD45B35),
              ),
            );
          },
        )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 400.ms);
  }

  Widget _buildAppName() {
    return Text(
          'Travel Guide',
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        )
        .animate(delay: 300.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, curve: Curves.easeOut);
  }

  Widget _buildTagline() {
    return Text(
          'Découvrez le Maroc',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 2,
            fontWeight: FontWeight.w300,
          ),
        )
        .animate(delay: 500.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, curve: Curves.easeOut);
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    ).animate(delay: 700.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildBottomBranding() {
    return Column(
      children: [
        Text(
          'MAROC',
          style: AppTextStyles.labelLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            letterSpacing: 8,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    ).animate(delay: 800.ms).fadeIn(duration: 600.ms);
  }
}
