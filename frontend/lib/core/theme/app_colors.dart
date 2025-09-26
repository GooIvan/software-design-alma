import 'package:flutter/material.dart';

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
