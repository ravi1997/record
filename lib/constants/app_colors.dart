import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006A6A);
  static const Color secondary = Color(0xFF4F6363);
  static const Color accent = Color(0xFFFFD6810);
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF006A6A);
  static const Color warning = Color(0xFFFFD6810);
  static const Color info = Color(0xFF006A6A);

  static const Color background = Color(0xFFFBFDFA);
  static const Color surface = Color(0xFFFBFDFA);
  static const Color onBackground = Color(0xFF191C1C);
  static const Color onSurface = Color(0xFF191C1C);

  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF9CF0E9),
    onPrimaryContainer: const Color(0xFF00201F),
    secondary: secondary,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFCCE7E6),
    onSecondaryContainer: const Color(0xFF051F1F),
    tertiary: const Color(0xFF4B5D7D),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFD2E3FF),
    onTertiaryContainer: const Color(0xFF001936),
    error: error,
    onError: Colors.white,
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: const Color(0xFFDAE5E4),
    onSurfaceVariant: const Color(0xFF3F4948),
    outline: const Color(0xFF6F7979),
    outlineVariant: const Color(0xFFBEC9C8),
    scrim: Colors.black,
    inverseSurface: const Color(0xFF2D3131),
    inversePrimary: const Color(0xFF80D4CD),
    surfaceTint: primary,
    shadow: Colors.black,
  );

  static ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF80D4CD),
    onPrimary: const Color(0xFF003735),
    primaryContainer: const Color(0xFF00504E),
    onPrimaryContainer: const Color(0xFF9CF0E9),
    secondary: const Color(0xFFB0CBCA),
    onSecondary: const Color(0xFF1B3534),
    secondaryContainer: const Color(0xFF324B4B),
    onSecondaryContainer: const Color(0xFFCCE7E6),
    tertiary: const Color(0xFFB1C7EB),
    onTertiary: const Color(0xFF1B304D),
    tertiaryContainer: const Color(0xFF324765),
    onTertiaryContainer: const Color(0xFFD2E3FF),
    error: error,
    onError: Colors.white,
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
    surface: const Color(0xFF111414),
    onSurface: const Color(0xFFE1E3E2),
    surfaceContainerHighest: const Color(0xFF3F4948),
    onSurfaceVariant: const Color(0xFFBEC9C8),
    outline: const Color(0xFF899392),
    outlineVariant: const Color(0xFF3F4948),
    scrim: Colors.black,
    inverseSurface: const Color(0xFFE1E3E2),
    inversePrimary: primary,
    surfaceTint: const Color(0xFF80D4CD),
    shadow: Colors.black,
  );
}
