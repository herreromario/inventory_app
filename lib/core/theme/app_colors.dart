import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Acción primaria: FAB, precios/valores monetarios, elemento activo de navegación, enlaces
  static const Color accent = Color(0xFF185FA5);

  // Éxito: estado positivo (stock ok), entradas de movimiento
  static const Color success = Color(0xFF3B6D11);
  static const Color successBackground = Color(0xFFEAF3DE);

  // Peligro: estado negativo (stock bajo), salidas de movimiento, acción destructiva
  static const Color danger = Color(0xFFA32D2D);
  static const Color dangerBackground = Color(0xFFFCEBEB);

  // Texto
  static const Color textPrimary = Color(0xFF1A1A18);
  static const Color textSecondary = Color(0xFF5F5E5A);
  static const Color textMuted = Color(0xFF888780);

  // Fondos
  static const Color pageBackground = Color(0xFFFAFAF8);
  static const Color cardBackground = Color(0xFFF1EFE8);
  static const Color cardBackgroundElevated = Color(0xFFFFFFFF);

  // Borde: #000000 al 12% opacidad
  static const Color border = Color(0x1F000000);

  // Sombra de tarjetas: #000000 al 4% opacidad
  static final Color cardShadow = Colors.black.withValues(alpha: 0.04);

  // Compatibilidad con ColorScheme
  static const Color primary = accent;
  static const Color error = danger;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = textPrimary;
  static const Color onError = Color(0xFFFFFFFF);
}
