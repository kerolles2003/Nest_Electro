import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Storefront design tokens, ported from
/// `apps/storefront/src/app/globals.css` (`:root` = light, `.dark` = dark).
/// Primary is crimson on light, cyan on dark — same as the web storefront.
abstract final class AppColors {
  // Light.
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightForeground = Color(0xFF1A1A2E);
  static const Color lightPrimary = Color(0xFFCF3549);
  static const Color lightPrimaryHover = Color(0xFFB82A40);
  static const Color lightPrimaryBright = Color(0xFFFF8B99);
  static const Color lightSecondary = Color(0xFFF1F5F9);
  static const Color lightMuted = Color(0xFFF8F8F8);
  static const Color lightBorder = Color(0xFFEAEAEC);
  static const Color lightMutedForeground = Color(0xFF5F6873);
  static const Color lightDanger = Color(0xFFDC2626);
  static const Color lightSuccess = Color(0xFF16A34A);
  static const Color lightWarning = Color(0xFFB45309);
  static const Color lightRing = Color(0xFFEB414B);

  // Dark.
  static const Color darkBackground = Color(0xFF0C1322);
  static const Color darkForeground = Color(0xFFE2E8F0);
  static const Color darkPrimary = Color(0xFF00D4FF);
  static const Color darkPrimaryHover = Color(0xFF00B8E6);
  static const Color darkSecondary = Color(0xFF191F2F);
  static const Color darkMuted = Color(0xFF1E2638);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkMutedForeground = Color(0xFF64748B);
  static const Color darkDanger = Color(0xFFEF4444);
  static const Color darkSuccess = Color(0xFF22C55E);
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkRing = Color(0xFF00D4FF);
}

/// App theme built from the storefront tokens.
/// Body text: Albert Sans. Headings: Urbanist (D-03).
abstract final class AppTheme {
  static ThemeData get light => _build(
        scheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: Colors.white,
          secondary: AppColors.lightSecondary,
          onSecondary: AppColors.lightForeground,
          surface: AppColors.lightBackground,
          onSurface: AppColors.lightForeground,
          surfaceContainerLow: AppColors.lightMuted,
          error: AppColors.lightDanger,
          onError: Colors.white,
          outline: AppColors.lightBorder,
          tertiary: AppColors.lightSuccess,
        ),
        dark: false,
      );

  static ThemeData get dark => _build(
        scheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkBackground,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkForeground,
          surface: AppColors.darkBackground,
          onSurface: AppColors.darkForeground,
          surfaceContainerLow: AppColors.darkSecondary,
          error: AppColors.darkDanger,
          onError: Colors.white,
          outline: AppColors.darkBorder,
          tertiary: AppColors.darkSuccess,
        ),
        dark: true,
      );

  static TextTheme _textTheme({required bool dark}) {
    final TextTheme base =
        dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final TextTheme body = GoogleFonts.albertSansTextTheme(base);
    return body.copyWith(
      displayLarge: GoogleFonts.urbanist(textStyle: body.displayLarge),
      displayMedium: GoogleFonts.urbanist(textStyle: body.displayMedium),
      displaySmall: GoogleFonts.urbanist(textStyle: body.displaySmall),
      headlineLarge: GoogleFonts.urbanist(textStyle: body.headlineLarge),
      headlineMedium: GoogleFonts.urbanist(textStyle: body.headlineMedium),
      headlineSmall: GoogleFonts.urbanist(textStyle: body.headlineSmall),
      titleLarge: GoogleFonts.urbanist(textStyle: body.titleLarge),
    );
  }

  static ThemeData _build({required ColorScheme scheme, required bool dark}) {
    final Color primary = scheme.primary;
    return ThemeData(
      colorScheme: scheme,
      brightness: dark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      textTheme: _textTheme(dark: dark),
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: dark ? AppColors.darkBackground : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: dark ? AppColors.darkSecondary : Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: primary.withValues(alpha: 0.12),
        labelStyle: TextStyle(color: scheme.onSurface),
      ),
      dividerColor: scheme.outline,
    );
  }
}
