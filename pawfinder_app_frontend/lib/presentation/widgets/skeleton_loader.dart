import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  factory SkeletonLoader.card() {
    return const SkeletonLoader(
      width: 320,
      height: 120,
      borderRadius: 16,
    );
  }

  factory SkeletonLoader.listItem() {
    return const SkeletonLoader(
      width: double.infinity,
      height: 80,
      borderRadius: 12,
    );
  }

  factory SkeletonLoader.circle({double size = 48}) {
    return SkeletonLoader(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }

  factory SkeletonLoader.banner() {
    return const SkeletonLoader(
      width: double.infinity,
      height: 200,
      borderRadius: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.ink100,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.ink100,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
