import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryDark,
        surface: AppColors.white,
        surfaceVariant: AppColors.backgroundLight,
        background: AppColors.backgroundLight,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.white,
        outline: AppColors.borderLight,
        shadow: AppColors.shadowLight,
      ),
      textTheme: GoogleFonts.quanticoTextTheme().copyWith(
        displayLarge: GoogleFonts.quantico(color: AppColors.textPrimary),
        displayMedium: GoogleFonts.quantico(color: AppColors.textPrimary),
        displaySmall: GoogleFonts.quantico(color: AppColors.textPrimary),
        headlineLarge: GoogleFonts.quantico(color: AppColors.textPrimary),
        headlineMedium: GoogleFonts.quantico(color: AppColors.textPrimary),
        headlineSmall: GoogleFonts.quantico(color: AppColors.textPrimary),
        titleLarge: GoogleFonts.quantico(color: AppColors.textPrimary),
        titleMedium: GoogleFonts.quantico(color: AppColors.textPrimary),
        titleSmall: GoogleFonts.quantico(color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.quantico(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.quantico(color: AppColors.textSecondary),
        bodySmall: GoogleFonts.quantico(color: AppColors.textLight),
        labelLarge: GoogleFonts.quantico(color: AppColors.textPrimary),
        labelMedium: GoogleFonts.quantico(color: AppColors.textSecondary),
        labelSmall: GoogleFonts.quantico(color: AppColors.textLight),
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.shadowLight,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        shadowColor: AppColors.shadowLight,
        elevation: 4,
      ),
      dividerColor: AppColors.borderLight,
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryDark,
        surface: Color(0xFF1A2B3A),
        surfaceVariant: Color(0xFF243545),
        background: Color(0xFF0F1A24),
        error: AppColors.error,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.white,
        outline: Color(0xFF3A4F5F),
        shadow: AppColors.shadowDark,
      ),
      textTheme: GoogleFonts.quanticoTextTheme().copyWith(
        displayLarge: GoogleFonts.quantico(color: AppColors.white),
        displayMedium: GoogleFonts.quantico(color: AppColors.white),
        displaySmall: GoogleFonts.quantico(color: AppColors.white),
        headlineLarge: GoogleFonts.quantico(color: AppColors.white),
        headlineMedium: GoogleFonts.quantico(color: AppColors.white),
        headlineSmall: GoogleFonts.quantico(color: AppColors.white),
        titleLarge: GoogleFonts.quantico(color: AppColors.white),
        titleMedium: GoogleFonts.quantico(color: AppColors.white),
        titleSmall: GoogleFonts.quantico(color: AppColors.white),
        bodyLarge: GoogleFonts.quantico(color: AppColors.white),
        bodyMedium: GoogleFonts.quantico(color: const Color(0xFFB3B3B3)),
        bodySmall: GoogleFonts.quantico(color: const Color(0xFF808080)),
        labelLarge: GoogleFonts.quantico(color: AppColors.white),
        labelMedium: GoogleFonts.quantico(color: const Color(0xFFB3B3B3)),
        labelSmall: GoogleFonts.quantico(color: const Color(0xFF808080)),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1A24),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A2B3A),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        surfaceTintColor: Color(0xFF1A2B3A),
        shadowColor: Color(0x3F000000),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1A2B3A),
        shadowColor: Color(0x66000000),
        elevation: 4,
      ),
      dividerColor: const Color(0xFF3A4F5F),
      iconTheme: const IconThemeData(
        color: Color(0xFFB3B3B3),
      ),
    );
  }
}

class AppColors {
  // Constructor privado para evitar instanciación
  AppColors._();

  /// Color primario de la aplicación
  static const Color primary = Color(0xFF29B6F6);

  /// Variaciones del color primario
  static const Color primaryLight = Color(0xFF73E8FF);
  static const Color primaryDark = Color(0xFF0086C3);

  /// Colores secundarios derivados
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF64D8CB);
  static const Color secondaryDark = Color(0xFF00766C);

  /// Colores de estado
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  /// Colores neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6C757D);
  static const Color greyLight = Color(0xFFF8F9FA);
  static const Color greyMedium = Color(0xFFE9ECEF);
  static const Color greyDark = Color(0xFF495057);

  /// Colores de texto
  static const Color textPrimary = Color.fromRGBO(33, 37, 41, 1);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Colores de fondo
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFFF5F5F5);

  /// Colores de superficie
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  /// Colores de borde
  static const Color border = Color(0xFFDEE2E6);
  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color borderDark = Color(0xFFADB5BD);

  /// Colores de sombra
  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x3F000000);
}
