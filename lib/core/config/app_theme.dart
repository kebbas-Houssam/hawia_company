import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from logo
  static const Color primary = Color(0xFF0B574B);
  static const Color secondary = Color(0xFFE38214);

  // Background colors
  static const Color backgroundPrimary = Color(0xFFF9FAFB);
  static const Color backgroundSecondary = Color(0xFFE6F4F2);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // Basic colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF3A3E40);
  static const Color transparent = Colors.transparent;

  // Status colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Input field colors
  static const Color inputBorder = Color(0xFFD1D5DB);
  static const Color inputFocus = Color(0xFF0B574B);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputHint = Color(0xFF9CA3AF);

  // Surface colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Border colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);

  // Shadow colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x26000000);

  // Gradient colors
  static const Color gradientStart = Color(0xFF0B574B);
  static const Color gradientEnd = Color(0xFFE28114);

  // Container specific colors
  static const Color containerBackground = Color(0xFFFFFFFF);
  static const Color containerBorder = Color(0xFFE5E7EB);
  static const Color containerShadow = Color(0x0A000000);

  // Button colors
  static const Color buttonPrimary = Color(0xFF0B574B);
  static const Color buttonSecondary = Color(0xFFE28114);
  static const Color buttonDisabled = Color(0xFFD1D5DB);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonTextSecondary = Color(0xFF374151);

  // Icon colors
  static const Color iconPrimary = Color(0xFF374151);
  static const Color iconSecondary = Color(0xFF6B7280);
  static const Color iconLight = Color(0xFF9CA3AF);
  static const Color iconWhite = Color(0xFFFFFFFF);

  // Overlay colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Divider colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFF3F4F6);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Tajawal',
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Tajawal',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputFocus, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderLight),
        ),
        color: AppColors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
