import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum InfoBannerType { info, success, warning, error }

class InfoBanner extends StatelessWidget {
  final String message;
  final InfoBannerType type;
  final VoidCallback? onTap;

  const InfoBanner({
    super.key,
    required this.message,
    this.type = InfoBannerType.info,
    this.onTap,
  });

  Color _backgroundColor() {
    switch (type) {
      case InfoBannerType.info:
        return AppColors.secondaryLight;
      case InfoBannerType.success:
        return AppColors.successLight;
      case InfoBannerType.warning:
        return AppColors.rewardLight;
      case InfoBannerType.error:
        return AppColors.dangerLight;
    }
  }

  Color _iconColor() {
    switch (type) {
      case InfoBannerType.info:
        return AppColors.secondary;
      case InfoBannerType.success:
        return AppColors.success;
      case InfoBannerType.warning:
        return AppColors.rewardDark;
      case InfoBannerType.error:
        return AppColors.danger;
    }
  }

  IconData _icon() {
    switch (type) {
      case InfoBannerType.info:
        return Icons.info_outline;
      case InfoBannerType.success:
        return Icons.check_circle_outline;
      case InfoBannerType.warning:
        return Icons.warning_amber_outlined;
      case InfoBannerType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              _icon(),
              size: AppSpacing.iconMedium,
              color: _iconColor(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(
                  color: _iconColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
