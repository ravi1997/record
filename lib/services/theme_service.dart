import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'app_theme';

  // Singleton instance
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Available themes
  static final List<AppTheme> availableThemes = [
    AppTheme(name: 'Light Blue', id: 'light_blue', themeData: lightBlueTheme),
    AppTheme(name: 'Dark Blue', id: 'dark_blue', themeData: darkBlueTheme),
    AppTheme(
      name: 'Light Green',
      id: 'light_green',
      themeData: lightGreenTheme,
    ),
    AppTheme(name: 'Dark Green', id: 'dark_green', themeData: darkGreenTheme),
  ];

  // Get current theme
  Future<ThemeData> getCurrentTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeId = prefs.getString(_themeKey) ?? 'light_blue';
      return getThemeById(themeId).themeData;
    } catch (e) {
      // Return default theme if there's an error
      return lightBlueTheme;
    }
  }

  // Save theme preference
  Future<void> saveTheme(String themeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeId);
  }

  // Get theme by ID
  static AppTheme getThemeById(String id) {
    return availableThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => availableThemes[0],
    );
  }

  // Get all theme names
  static List<String> getThemeNames() {
    return availableThemes.map((theme) => theme.name).toList();
  }

  // Get theme ID by name
  static String getThemeIdByName(String name) {
    return availableThemes
        .firstWhere(
          (theme) => theme.name == name,
          orElse: () => availableThemes[0],
        )
        .id;
  }
}

// App theme model
class AppTheme {
  final String name;
  final String id;
  final ThemeData themeData;

  AppTheme({required this.name, required this.id, required this.themeData});
}

// Predefined themes
final ThemeData lightBlueTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

final ThemeData darkBlueTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

final ThemeData lightGreenTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

final ThemeData darkGreenTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
