import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4F9CF9); // Biru dari Figma
  static const Color backgroundColor = Color(0xFFF5F5F5); // Abu terang
  static const Color accentColor = Color(0xFF1E88E5); // Biru sedikit lebih gelap

  static const Color successColor = Color(0xFF4CAF50); // Hijau
  static const Color warningColor = Color(0xFFFFA726); // Oranye
  static const Color errorColor = Color(0xFFF44336);   // Merah

  static const Color textColorBlack = Color(0xFF212121); // Hitam
  static const Color textColorWhite = Color(0xFFFFFFFF); // Putih
  static const Color redCard = Color(0xFFEF5350); // Merah untuk card
  static const Color blueCard = Color(0xFF42A5F5); // Biru untuk card

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      secondaryHeaderColor: Color(0xFFF5F5F5), // Abu terang
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        error: errorColor,
        onPrimary: textColorWhite,
        onSecondary: textColorWhite,
        onSurface: textColorBlack,
        onError: textColorWhite,
        primaryContainer: Color(0xFFAFDDFF), // Biru muda untuk card
        secondaryContainer: Color.fromARGB(255, 255, 255, 255), // Biru muda untuk card
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        labelLarge: TextStyle(fontSize: 12, color: Colors.black54),
        labelMedium: TextStyle(fontSize: 18, color: Colors.black54),
        labelSmall: TextStyle(fontSize: 11, color: Colors.black54),
      ),
      fontFamily: 'Poppins',
    );
  }
}
