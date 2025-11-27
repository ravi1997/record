import 'package:flutter/material.dart';
import 'app_colors.dart';

// Theme Constants with Material 3 Guidelines
class ThemeConstants {
  // Material 3 Color Schemes
  static ColorScheme lightColorScheme = AppColors.lightColorScheme;
  static ColorScheme darkColorScheme = AppColors.darkColorScheme;

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
}
