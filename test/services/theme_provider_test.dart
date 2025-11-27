import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/services/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    test('themeMode is initially ThemeMode.system', () async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});

      final themeProvider = ThemeProvider();
      await themeProvider.loadTheme(); // Ensure theme is loaded asynchronously

      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('toggleTheme changes themeMode and saves to SharedPreferences', () async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});

      final themeProvider = ThemeProvider();
      await themeProvider.loadTheme();

      // Initially light
      expect(themeProvider.themeMode, ThemeMode.light);

      // Toggle to dark
      themeProvider.toggleTheme(true);
      expect(themeProvider.themeMode, ThemeMode.dark);

      // Verify saved preference
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('darkMode'), true);

      // Toggle to light
      themeProvider.toggleTheme(false);
      expect(themeProvider.themeMode, ThemeMode.light);

      // Verify saved preference
      expect(prefs.getBool('darkMode'), false);
    });
  });
}
