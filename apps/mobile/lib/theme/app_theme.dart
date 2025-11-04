import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color tertiaryColor = Color(0xFF06B6D4);
  static const Color surfaceColor = Color(0xFFFAFBFC);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color onSurfaceColor = Color(0xFF0F172A);
  static const Color outlineColor = Color(0xFFE2E8F0);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  static ThemeData get lightTheme {
    return _buildTheme(false);
  }

  static ThemeData get darkTheme {
    return _buildTheme(true);
  }

  static ThemeData _buildTheme(bool isDark) {
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFFAFBFC);
    final cardColor = isDark ? const Color(0xFF334155) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        outline: isDark ? const Color(0xFF475569) : outlineColor,
        error: errorColor,
        onError: Colors.white,
        onBackground: textColor,
        onTertiary: Colors.white,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: onSurfaceColor,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w400,
          color: onSurfaceColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor.withOpacity(0.95),
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: onSurfaceColor,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: cardColor,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 20,
        offset: const Offset(0, 4),
      );

  static BoxShadow get elevatedShadow => BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 30,
        offset: const Offset(0, 8),
      );

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [primaryColor, secondaryColor],
      );

  static LinearGradient get surfaceGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          primaryColor.withOpacity(0.02),
        ],
      );
}