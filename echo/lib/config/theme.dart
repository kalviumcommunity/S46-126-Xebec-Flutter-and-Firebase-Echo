import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ==================== COLOR PALETTE ====================
  
  // Light Theme Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightCardBackground = Colors.white;
  
  // Dark Theme Colors - Futuristic Palette
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color darkSurface = Color(0xFF151B3D);
  static const Color darkCard = Color(0xFF1E2749);
  
  // Accent Colors - Neon/Futuristic
  static const Color neonBlue = Color(0xFF00D9FF);
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonGreen = Color(0xFF00F5A0);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFF9D4EDD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0E27), Color(0xFF1E2749)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== LIGHT THEME ====================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: lightBackground,
      
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: neonPurple,
        surface: lightCardBackground,
        background: lightBackground,
        error: neonPink,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkGrey,
        onBackground: darkGrey,
      ),
      
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkGrey),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkGrey),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkGrey),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: darkGrey),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkGrey),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkGrey),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: darkGrey),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkGrey),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkGrey),
          bodyLarge: TextStyle(fontSize: 16, color: darkGrey),
          bodyMedium: TextStyle(fontSize: 14, color: darkGrey),
          bodySmall: TextStyle(fontSize: 12, color: darkGrey),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkGrey),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: darkGrey),
          labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: darkGrey),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: lightCardBackground,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkGrey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkGrey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // ==================== DARK THEME ====================
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: neonBlue,
      scaffoldBackgroundColor: darkBackground,
      
      colorScheme: ColorScheme.dark(
        primary: neonBlue,
        secondary: neonPurple,
        surface: darkCard,
        background: darkBackground,
        error: neonPink,
        onPrimary: darkBackground,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
          bodySmall: TextStyle(fontSize: 12, color: Colors.white60),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
          labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkCard,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: neonBlue,
          foregroundColor: darkBackground,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonBlue, width: 2),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonBlue,
        foregroundColor: darkBackground,
        elevation: 4,
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: neonBlue,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // ==================== GLASSMORPHISM UTILITY ====================
  
  static BoxDecoration glassmorphism({
    Color? color,
    double blur = 10,
    double opacity = 0.1,
    BorderRadius? borderRadius,
    Border? border,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: border ?? Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
