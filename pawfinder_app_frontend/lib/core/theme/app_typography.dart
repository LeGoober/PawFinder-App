import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontDisplay = 'Outfit';
  static const String fontBody = 'PlusJakartaSans';

  // ── Display Voice: Outfit ──
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.ink900,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.ink900,
      );

  static TextStyle get displaySmall => GoogleFonts.outfit(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.ink900,
      );

  static TextStyle get h1 => GoogleFonts.outfit(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.3,
        color: AppColors.ink900,
      );

  static TextStyle get h2 => GoogleFonts.outfit(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.ink900,
      );

  static TextStyle get h3 => GoogleFonts.outfit(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.ink900,
      );

  // ── Body Voice: Plus Jakarta Sans ──
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.ink700,
      );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.ink700,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.ink500,
      );

  // ── Button: Outfit ──
  static TextStyle get button => GoogleFonts.outfit(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.5,
        color: Colors.white,
      );

  // ── Caption & Label: Plus Jakarta Sans ──
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.2,
        color: AppColors.ink500,
      );

  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.ink700,
      );

  // ── Material TextTheme ──
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: h1,
        headlineMedium: h2,
        headlineSmall: h3,
        titleLarge: bodyLarge,
        titleMedium: body,
        titleSmall: bodySmall,
        bodyLarge: bodyLarge,
        bodyMedium: body,
        bodySmall: bodySmall,
        labelLarge: button,
        labelMedium: label,
        labelSmall: caption,
      );
}
