import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get _poppins => GoogleFonts.poppins();
  static TextStyle get _inter => GoogleFonts.inter();

  // Headings (Poppins)
  static TextStyle heading1 = _poppins.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = _poppins.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = _poppins.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body (Inter)
  static TextStyle bodyLarge = _inter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = _inter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = _inter.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // Labels (Inter medium)
  static TextStyle label = _inter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = _inter.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Button (Poppins)
  static TextStyle button = _poppins.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.scaffold,
  );
}
