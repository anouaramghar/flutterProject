import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/place_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/app_styles.dart';
import 'views/home/home_page.dart';
import 'views/onboarding/onboarding_page.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize theme provider early
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(TravelGuideApp(themeProvider: themeProvider));
}

class TravelGuideApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const TravelGuideApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Travel Guide Maroc',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppRouter(),
          );
        },
      ),
    );
  }
}

/// Router widget that checks onboarding status and displays appropriate screen
class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  bool? _hasCompletedOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Simulate splash screen delay for a smoother experience
    await Future.delayed(const Duration(milliseconds: 1500));

    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;

    if (mounted) {
      setState(() {
        _hasCompletedOnboarding = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while checking status
    if (_hasCompletedOnboarding == null) {
      return const SplashScreen();
    }

    // Navigate based on onboarding status
    if (_hasCompletedOnboarding!) {
      return const HomePage();
    } else {
      return const OnboardingPage();
    }
  }
}
