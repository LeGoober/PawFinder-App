import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static TextStyle get displayLarge => TextStyle(
        fontFamily: 'Inter',
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.ink900,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: 'Inter',
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.ink900,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: 'Inter',
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.ink900,
      );

  static TextStyle get h1 => TextStyle(
        fontFamily: 'Inter',
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.3,
        color: AppColors.ink900,
      );

  static TextStyle get h2 => TextStyle(
        fontFamily: 'Inter',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.ink900,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: 'Inter',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.ink900,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontFamily: 'Inter',
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.ink700,
      );

  static TextStyle get body => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.ink700,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: 'Inter',
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.ink500,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: 'Inter',
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.2,
        color: AppColors.ink500,
      );

  static TextStyle get button => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.3,
      );

  static TextStyle get label => TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.ink700,
      );

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
