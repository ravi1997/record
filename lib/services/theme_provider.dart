import 'package:flutter/material.dart';
import 'package:record/services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    _themeMode = await _themeService.getCurrentThemeMode();
    notifyListeners();
  }

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _themeService.saveThemeMode(_themeMode);
    notifyListeners();
  }
}
