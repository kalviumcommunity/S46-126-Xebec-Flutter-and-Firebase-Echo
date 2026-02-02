import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkGrey = Color(0xFF424242);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        brightness: Brightness.light,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkGrey),
        displayMedium: TextStyle(color: darkGrey),
        displaySmall: TextStyle(color: darkGrey),
        headlineLarge: TextStyle(color: darkGrey),
        headlineMedium: TextStyle(color: darkGrey),
        headlineSmall: TextStyle(color: darkGrey),
        titleLarge: TextStyle(color: darkGrey),
        titleMedium: TextStyle(color: darkGrey),
        titleSmall: TextStyle(color: darkGrey),
        bodyLarge: TextStyle(color: darkGrey),
        bodyMedium: TextStyle(color: darkGrey),
        bodySmall: TextStyle(color: darkGrey),
        labelLarge: TextStyle(color: darkGrey),
        labelMedium: TextStyle(color: darkGrey),
        labelSmall: TextStyle(color: darkGrey),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        brightness: Brightness.dark,
        surface: darkSurface,
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
    );
  }
}
