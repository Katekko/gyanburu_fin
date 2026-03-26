import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "The Luminous Ledger" design system
class AppColors {
  static const deepPurple = Color(0xFF6200EE);
  static const vibrantOrange = Color(0xFFFF9800);
  static const surface = Color(0xFF121212);
  static const surfaceVariant = Color(0xFF1E1E1E);
  static const surfaceElevated = Color(0xFF2C2C2C);
  static const surfaceHighlight = Color(0xFF383838);
  static const textPrimary = Color(0xFFE0E0E0);
  static const textSecondary = Color(0xFF9E9E9E);
  static const textMuted = Color(0xFF616161);
  static const positive = Color(0xFF4CAF50);
  static const negative = Color(0xFFEF5350);
  static const divider = Color(0xFF2C2C2C);
}

ThemeData buildAppTheme() {
  final headlineFont = GoogleFonts.manropeTextTheme();
  final bodyFont = GoogleFonts.interTextTheme();

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.deepPurple,
      secondary: AppColors.vibrantOrange,
      surface: AppColors.surface,
      error: AppColors.negative,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: headlineFont.displayLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: headlineFont.headlineLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: headlineFont.headlineMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: headlineFont.headlineSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: headlineFont.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: bodyFont.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: bodyFont.bodyLarge?.copyWith(color: AppColors.textPrimary),
      bodyMedium: bodyFont.bodyMedium?.copyWith(color: AppColors.textPrimary),
      bodySmall: bodyFont.bodySmall?.copyWith(color: AppColors.textSecondary),
      labelLarge: bodyFont.labelLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: bodyFont.labelMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      labelSmall: bodyFont.labelSmall?.copyWith(color: AppColors.textMuted),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: headlineFont.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedIconTheme: const IconThemeData(color: AppColors.deepPurple),
      unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
      selectedLabelTextStyle: bodyFont.labelMedium?.copyWith(
        color: AppColors.deepPurple,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: bodyFont.labelMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      indicatorColor: AppColors.deepPurple.withValues(alpha: 0.15),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.deepPurple,
        side: const BorderSide(color: AppColors.deepPurple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceElevated,
      selectedColor: AppColors.deepPurple.withValues(alpha: 0.2),
      labelStyle: bodyFont.labelMedium?.copyWith(color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
