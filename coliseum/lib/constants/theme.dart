import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF000000);
  static const Color lightSecondary = Color(0xFF3897f0);
  static const Color lightAccent = Color(0xFFEFEFEF); // Lighter grey for fields
  static const Color lightCard = Color(0xFFFAFAFA);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFF3897f0);
  static const Color darkAccent = Color(0xFF262626); // Dark grey for fields
  static const Color darkCard = Color(0xFF121212);
  
  // Common Colors
  static const Color error = Color(0xFFED4956);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF8e8e8e);
}

class AppTheme {
  static final ThemeData lightTheme = _buildTheme(isDark: false);
  static final ThemeData darkTheme = _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    // Define ThemeData
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      primaryColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        onPrimary: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        background: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        onBackground: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        surface: isDark ? AppColors.darkCard : AppColors.lightCard,
        onSurface: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        surfaceVariant: isDark ? AppColors.darkAccent : AppColors.lightAccent,
        onSurfaceVariant: AppColors.grey,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        foregroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'InstagramSans',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
        hintStyle: const TextStyle(
          color: AppColors.grey,
        ),
        iconColor: AppColors.grey,
        prefixIconColor: AppColors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),

      textTheme: TextTheme(
        headlineSmall: const TextStyle(fontFamily: 'InstagramSans', fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: const TextStyle(fontFamily: 'InstagramSans', fontWeight: FontWeight.bold, fontSize: 22),
        titleMedium: const TextStyle(fontFamily: 'InstagramSans', fontWeight: FontWeight.bold, fontSize: 16),
        titleSmall: const TextStyle(fontFamily: 'InstagramSans', fontWeight: FontWeight.bold, fontSize: 14),
        bodyLarge: const TextStyle(fontFamily: 'InstagramSans', fontSize: 16),
        bodyMedium: const TextStyle(fontFamily: 'InstagramSans', fontSize: 14),
      ).apply(
        bodyColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        displayColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      ),
    );
  }
} 