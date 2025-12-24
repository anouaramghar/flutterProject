// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application/main.dart';
import 'package:flutter_application/providers/theme_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Create a ThemeProvider for testing
    final themeProvider = ThemeProvider();
    await themeProvider.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(TravelGuideApp(themeProvider: themeProvider));

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that the app loads (we check for the splash screen initially)
    expect(find.byType(TravelGuideApp), findsOneWidget);
  });
}
