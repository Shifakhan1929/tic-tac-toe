import 'package:flutter/material.dart';

/// Central theme configuration for the Tic-Tac-Toe app.
/// Implements a sleek, modern dark theme with vibrant accents for X and O.
class AppTheme {
  // Brand & Background Colors
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B);    // Slate 800
  static const Color surfaceLight = Color(0xFF334155); // Slate 700
  static const Color border = Color(0xFF475569);     // Slate 600

  // Player & Outcome Colors
  static const Color playerXColor = Color(0xFF06B6D4); // Electric Cyan
  static const Color playerOColor = Color(0xFFF43F5E); // Sunset Rose
  static const Color drawColor = Color(0xFF94A3B8);    // Cool Slate Gray
  static const Color winningGlow = Color(0xFFF59E0B);  // Radiant Amber / Gold

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: playerXColor,
        secondary: playerOColor,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceLight,
          foregroundColor: textPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
