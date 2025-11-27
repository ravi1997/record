import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../constants/theme_constants.dart';

class ThemeService {
  // Singleton instance
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Current theme settings
  String _currentThemeId = AppConstants.defaultThemeId;
  ThemeMode _currentThemeMode = ThemeMode.system;

  // Theme mode listener
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  // Available themes
  static final List<AppTheme> availableThemes = [
    AppTheme(
        name: 'Light Blue',
        id: AppConstants.lightBlueThemeId,
        themeData: lightBlueTheme),
    AppTheme(
        name: 'Dark Blue',
        id: AppConstants.darkBlueThemeId,
        themeData: darkBlueTheme),
    AppTheme(
      name: 'Light Green',
      id: AppConstants.lightGreenThemeId,
      themeData: lightGreenTheme,
    ),
    AppTheme(
        name: 'Dark Green',
        id: AppConstants.darkGreenThemeId,
        themeData: darkGreenTheme),
  ];

  // Get current theme synchronously
  ThemeData getCurrentTheme() {
    final selectedTheme = getThemeById(_currentThemeId);
    return selectedTheme.themeData;
  }

  // Get current theme mode
  Future<ThemeMode> getCurrentThemeMode() async {
    await loadThemeMode();
    return _currentThemeMode;
  }

  // Load theme mode from preferences
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool('darkMode') ?? false;
    _currentThemeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    themeModeNotifier.value = _currentThemeMode;
  }

  // Save theme preference
  void saveTheme(String themeId) {
    _currentThemeId = themeId;
  }

  // Save theme mode preference
  void saveThemeMode(ThemeMode themeMode) async {
    _currentThemeMode = themeMode;
    themeModeNotifier.value = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', themeMode == ThemeMode.dark);
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
    seedColor: ThemeConstants.primaryColor,
    brightness: Brightness.light,
  ),
  appBarTheme: ThemeConstants.appBarTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ThemeConstants.elevatedButtonStyle,
  ),
);

final ThemeData darkBlueTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ThemeConstants.primaryColor,
    brightness: Brightness.dark,
  ),
  appBarTheme: ThemeConstants.appBarTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ThemeConstants.elevatedButtonStyle,
  ),
);

final ThemeData lightGreenTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ThemeConstants.secondaryColor,
    brightness: Brightness.light,
  ),
  appBarTheme: ThemeConstants.appBarTheme.copyWith(
    backgroundColor: ThemeConstants.secondaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ThemeConstants.elevatedButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(ThemeConstants.secondaryColor),
    ),
  ),
);

final ThemeData darkGreenTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ThemeConstants.secondaryColor,
    brightness: Brightness.dark,
  ),
  appBarTheme: ThemeConstants.appBarTheme.copyWith(
    backgroundColor: ThemeConstants.secondaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ThemeConstants.elevatedButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(ThemeConstants.secondaryColor),
    ),
  ),
);
