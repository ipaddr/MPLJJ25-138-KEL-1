import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF60B5FF); // Biru dari Figma
  static const Color backgroundColor = Color(0xFFF5F5F5); // Abu terang
  static const Color accentColor = Color(
    0xFF1E88E5,
  ); // Biru sedikit lebih gelap
  static const Color black = Color(0xFF212121); // Hitam
  static const Color white = Color(0xFFFFFFFF); // Putih
  static const Color white_185 = Color.fromARGB(185, 255, 255, 255); // Putih

  static const Color successColor = Color(0xFF4CAF50); // Hijau
  static const Color warningColor = Color(0xFFFFA726); // Oranye
  static const Color errorColor = Color(0xFFF44336); // Merah

  static const Color textColorBlack = Color(0xFF212121); // Hitam
  static const Color textColorWhite = Color(0xFFFFFFFF); // Putih
  static const Color redCard = Color(0xFFEF5350); // Merah untuk card
  static const Color blueCard = Color(0xFF42A5F5); // Biru untuk card

  static const Color greenCard = Color(0xFF66BB6A); // Hijau untuk card
  static const Color greenCard_185 = Color.fromARGB(
    185,
    102,
    187,
    106,
  ); // Hijau untuk card

  static const Color progressCard = Color(0xFF6750A4); // Ungu untuk card
  static const Color progressCard_2 = Color(0xFFF8DEF5); // Abu-abu untuk card

  static const Color orangeCard = Color(0xFFFFA726); // Oranye untuk card
  static const Color orangeCard_185 = Color.fromARGB(
    185,
    255,
    167,
    38,
  ); // Oranye untuk card

  static const Color blueOld = Color(0xFF344CB7);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryColorLight: Color.fromARGB(255, 175, 221, 255),
      secondaryHeaderColor: Color(0xFFF5F5F5), // Abu terang
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Color(0xFFFF9149),
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
        secondaryContainer: Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // Biru muda untuk card
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        labelLarge: TextStyle(fontSize: 12, color: Colors.black54),
        labelMedium: TextStyle(fontSize: 18, color: Colors.black54),
        labelSmall: TextStyle(fontSize: 11, color: Colors.black54),
        headlineSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      fontFamily: 'Poppins',
    );
  }
}
