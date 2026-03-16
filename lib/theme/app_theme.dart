import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Obsidian & Emerald Color Palette
  static const Color backgroundDark = Color(0xFF0F2319);
  static const Color backgroundLight = Color(0xFFF5F8F7);
  static const Color primary = Color(0xFF00E677);
  static const Color primaryVariant = Color(0xFF00B35C);
  
  // Accents & Warnings
  static const Color textLight = Color(0xFFF1F5F9); // slate-100
  static const Color textMuted = Color(0xFF94A3B8); // slate-400
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);
  
  // Glassmorphism effects
  static const Color glassBackground = Color(0x08FFFFFF);
  static const Color glassBorder = Color(0x0DFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryVariant,
        surface: glassBackground,
        background: backgroundDark,
        error: dangerRed,
        onPrimary: backgroundDark,
        onSurface: textLight,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(color: textLight, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: textLight, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(color: textLight),
        bodyMedium: GoogleFonts.inter(color: textMuted),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
      ),
      cardTheme: CardTheme(
        color: glassBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: glassBackground,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: backgroundDark,
      ),
    );
  }
}
