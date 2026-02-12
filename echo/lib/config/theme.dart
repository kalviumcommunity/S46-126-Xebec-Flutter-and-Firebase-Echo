import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkGrey = Color(0xFF424242);
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
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
}
