import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  static SizedBox get xs => SizedBox(height: 4.h, width: 4.w);
  static SizedBox get sm => SizedBox(height: 8.h, width: 8.w);
  static SizedBox get md => SizedBox(height: 12.h, width: 12.w);
  static SizedBox get lg => SizedBox(height: 16.h, width: 16.w);
  static SizedBox get xl => SizedBox(height: 24.h, width: 24.w);
  static SizedBox get xxl => SizedBox(height: 32.h, width: 32.w);
  static SizedBox get xxxl => SizedBox(height: 48.h, width: 48.w);

  static EdgeInsets get paddingXs => EdgeInsets.all(4.r);
  static EdgeInsets get paddingSm => EdgeInsets.all(8.r);
  static EdgeInsets get paddingMd => EdgeInsets.all(12.r);
  static EdgeInsets get paddingLg => EdgeInsets.all(16.r);
  static EdgeInsets get paddingXl => EdgeInsets.all(24.r);
  static EdgeInsets get paddingXxl => EdgeInsets.all(32.r);

  static EdgeInsets get paddingHorizontalSm => EdgeInsets.symmetric(horizontal: 8.w);
  static EdgeInsets get paddingHorizontalMd => EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets get paddingHorizontalLg => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get paddingHorizontalXl => EdgeInsets.symmetric(horizontal: 24.w);

  static EdgeInsets get paddingVerticalSm => EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets get paddingVerticalMd => EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets get paddingVerticalLg => EdgeInsets.symmetric(vertical: 16.h);
  static EdgeInsets get paddingVerticalXl => EdgeInsets.symmetric(vertical: 24.h);

  static EdgeInsets get paddingCard => EdgeInsets.all(16.r);

  static double get buttonHeight => 56.h;
  static double get inputHeight => 56.h;
  static double get inputHeightMultiline => 120.h;

  static double get iconSmall => 16.w;
  static double get iconMedium => 24.w;
  static double get iconLarge => 32.w;

  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusPill => 999.r;

  // Navigation
  static double get bottomNavHeight => 64.h;
  static double get bottomNavIconSize => 24.w;

  // Cards
  static double get alertCardImageSize => 80.w;
  static double get statCardElevation => 1.0;
  static double get avatarSize => 48.w;
  static double get avatarSizeLarge => 72.w;
  static double get fabSize => 64.w;
  static double get heroImageHeight => 240.h;
  static double get mapPlaceholderHeight => 300.h;
}
