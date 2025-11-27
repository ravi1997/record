import 'package:flutter/material.dart';

// Theme Constants with Material 3 Guidelines
class ThemeConstants {
  // Material 3 Color System - Using proper tonal palettes
  static const Color primaryColor = Color(0xFF006A6A); // Teal 700
  static const Color secondaryColor = Color(0xFF4F6363); // Green 700
  static const Color accentColor = Color(0xFFFFD6810); // Orange 700
  static const Color errorColor = Color(0xFFBA1A1A); // Red 600
  static const Color successColor = Color(0xFF006A6A); // Teal 700
  static const Color warningColor = Color(0xFFFFD6810); // Orange 700
  static const Color infoColor = Color(0xFF006A6A); // Teal 700

  // Surface colors based on Material 3 specifications
  static const Color backgroundColor = Color(0xFFFBFDFA); // Light surface
  static const Color surfaceColor = Color(0xFFFBFDFA); // Light surface
  static const Color onBackgroundColor = Color(0xFF191C1C); // Light on surface
  static const Color onSurfaceColor = Color(0xFF191C1C); // Light on surface

  // Material 3 Color Schemes
  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF006A6A),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFF9CF0E9),
    onPrimaryContainer: const Color(0xFF00201F),
    secondary: const Color(0xFF4A6262),
    onSecondary: const Color(0xFFFFFFFF),
    secondaryContainer: const Color(0xFFCCE7E6),
    onSecondaryContainer: const Color(0xFF051F1F),
    tertiary: const Color(0xFF4B5D7D),
    onTertiary: const Color(0xFFFFFFFF),
    tertiaryContainer: const Color(0xFFD2E3FF),
    onTertiaryContainer: const Color(0xFF001936),
    error: const Color(0xFFBA1A1A),
    onError: const Color(0xFFFFFFFF),
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
    surface: const Color(0xFFFBFDFA),
    onSurface: const Color(0xFF191C1C),
    surfaceContainerHighest: const Color(0xFFDAE5E4),
    onSurfaceVariant: const Color(0xFF3F4948),
    outline: const Color(0xFF6F7979),
    outlineVariant: const Color(0xFFBEC9C8),
    scrim: const Color(0xFF000000),
    inverseSurface: const Color(0xFF2D3131),
    inversePrimary: const Color(0xFF80D4CD),
    surfaceTint: const Color(0xFF006A6A),
    shadow: const Color(0xFF000000),
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
    error: const Color(0xFFBA1A1A),
    onError: const Color(0xFFFFFFFF),
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
    surface: const Color(0xFF111414),
    onSurface: const Color(0xFFE1E3E2),
    surfaceContainerHighest: const Color(0xFF3F4948),
    onSurfaceVariant: const Color(0xFFBEC9C8),
    outline: const Color(0xFF899392),
    outlineVariant: const Color(0xFF3F4948),
    scrim: const Color(0xFF000000),
    inverseSurface: const Color(0xFFE1E3E2),
    inversePrimary: const Color(0xFF006A6A),
    surfaceTint: const Color(0xFF80D4CD),
    shadow: const Color(0xFF000000),
  );

  // App bar theme - Material 3 style with proper elevation and colors
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: lightColorScheme.onSurface,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 3,
    shadowColor: Colors.black.withAlpha(13),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onSurface,
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.onSurface,
    ),
  );

  // Button themes - Material 3 style with proper states and elevation
  static ButtonStyle elevatedButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(lightColorScheme.primary),
    foregroundColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
    elevation: WidgetStateProperty.all(2),
    shadowColor: WidgetStateProperty.all(lightColorScheme.primary.withAlpha(51)),
    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
    ),
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return lightColorScheme.onPrimary.withAlpha(26);
        }
        if (states.contains(WidgetState.hovered)) {
          return lightColorScheme.onPrimary.withAlpha(20);
        }
        if (states.contains(WidgetState.focused)) {
          return lightColorScheme.onPrimary.withAlpha(26);
        }
        return null;
      },
    ),
  );

  static ButtonStyle filledButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(lightColorScheme.primary),
    foregroundColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
    ),
  ).copyWith(
    // Add Material 3 states
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return lightColorScheme.onPrimary.withAlpha(26);
        }
        if (states.contains(WidgetState.hovered)) {
          return lightColorScheme.onPrimary.withAlpha(20);
        }
        if (states.contains(WidgetState.focused)) {
          return lightColorScheme.onPrimary.withAlpha(26);
        }
        return null;
      },
    ),
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: lightColorScheme.primary,
    side: BorderSide(color: lightColorScheme.outline),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
  ).copyWith(
    // Add Material 3 states
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return lightColorScheme.primary.withAlpha(26);
        }
        if (states.contains(WidgetState.hovered)) {
          return lightColorScheme.primary.withAlpha(20);
        }
        if (states.contains(WidgetState.focused)) {
          return lightColorScheme.primary.withAlpha(26);
        }
        return null;
      },
    ),
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: lightColorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
  ).copyWith(
    // Add Material 3 states
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return lightColorScheme.primary.withAlpha(26);
        }
        if (states.contains(WidgetState.hovered)) {
          return lightColorScheme.primary.withAlpha(20);
        }
        if (states.contains(WidgetState.focused)) {
          return lightColorScheme.primary.withAlpha(26);
        }
        return null;
      },
    ),
  );

  // Input decoration theme - Material 3 style with proper states
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: lightColorScheme.surfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    isDense: true,
    labelStyle: TextStyle(
      color: lightColorScheme.onSurfaceVariant,
      fontSize: 16,
    ),
    floatingLabelStyle: TextStyle(
      color: lightColorScheme.primary,
      fontSize: 12,
    ),
  );

  // Card theme - Material 3 style with proper elevation and shape
  static CardTheme cardTheme = CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 1,
    shadowColor: Colors.black.withAlpha(13),
    surfaceTintColor: Colors.transparent,
  );

  // Typography - Material 3 style with proper font weights and letter spacing
  static TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.00,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.00,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.00,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.00,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.00,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.40,
      color: lightColorScheme.onSurfaceVariant,
    ).apply(fontFamily: 'Roboto'),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
      color: lightColorScheme.onSurface,
    ).apply(fontFamily: 'Roboto'),
  );

  // Surface container colors for Material 3 hierarchy
  static Color surfaceContainerLow = const Color(0xFFF3F6F5);
  static Color surfaceContainer = const Color(0xFFEDEFEF);
  static Color surfaceContainerHigh = const Color(0xFFE7EAE9);
  static Color surfaceContainerHighest = const Color(0xFFE1E3E2);
}
