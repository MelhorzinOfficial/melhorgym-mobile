import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color scaffold = Color(0xFF0A0A0F);
  static const Color card = Color(0xFF141420);
  static const Color cardLight = Color(0xFF1C1C2E);
  static const Color input = Color(0xFF1A1A2C);
  static const Color surface = Color(0xFF111118);
  static const Color surfaceLight = Color(0xFF1E1E30);

  // Primary & Accent
  static const Color primary = Color(0xFF00E676);
  static const Color primaryLight = Color(0xFF69F0AE);
  static const Color primaryDark = Color(0xFF00C853);
  static const Color primaryMuted = Color(0xFF00E676);
  static const Color secondary = Color(0xFFFF6D00);
  static const Color secondaryLight = Color(0xFFFF9E40);
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentLight = Color(0xFFB388FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFE040FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF6D00), Color(0xFFFF3D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16162A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Day colors - cores únicas para cada dia de treino
  static const List<Color> dayColors = [
    Color(0xFF00E676), // Verde
    Color(0xFF448AFF), // Azul
    Color(0xFFFF6D00), // Laranja
    Color(0xFFE040FB), // Rosa
    Color(0xFFFFD600), // Amarelo
    Color(0xFF00BCD4), // Ciano
    Color(0xFFFF5252), // Vermelho
  ];

  static Color getDayColor(int index) => dayColors[index % dayColors.length];

  // Text
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9EAF);
  static const Color textTertiary = Color(0xFF5C5C6E);

  // Status
  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFF8A80);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);

  // Misc
  static const Color divider = Color(0xFF252538);
  static const Color shimmerBase = Color(0xFF1A1A2E);
  static const Color shimmerHighlight = Color(0xFF2A2A3E);
  static const Color overlay = Color(0x80000000);

  // Glass effect
  static Color glassWhite = Colors.white.withValues(alpha: 0.06);
  static Color glassBorder = Colors.white.withValues(alpha: 0.08);
}
