import 'package:flutter/material.dart';

class AppTheme {
  // Cores da marca JCB
  static const Color jcbYellow = Color(0xFFFFB300);
  static const Color jcbBlack = Color(0xFF000000);
  static const Color construccionOrange = Color(0xFFFF6B35);
  static const Color agroGreen = Color(0xFF4CAF50);
  
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: jcbYellow,
      scaffoldBackgroundColor: Colors.grey[50],
      colorScheme: ColorScheme.light(
        primary: jcbYellow,
        secondary: jcbBlack,
        surface: Colors.white,
        error: Colors.red[700]!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: jcbYellow,
        foregroundColor: jcbBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: jcbBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: jcbYellow,
          foregroundColor: jcbBlack,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      useMaterial3: true,
    );
  }
}
