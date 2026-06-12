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
        return AppColors.secondary.withValues(alpha: 0.12);
      case InfoBannerType.success:
        return AppColors.success.withValues(alpha: 0.12);
      case InfoBannerType.warning:
        return AppColors.reward.withValues(alpha: 0.12);
      case InfoBannerType.error:
        return AppColors.danger.withValues(alpha: 0.12);
    }
  }

  Color _iconColor() {
    switch (type) {
      case InfoBannerType.info:
        return AppColors.secondary;
      case InfoBannerType.success:
        return AppColors.success;
      case InfoBannerType.warning:
        return AppColors.reward;
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
        return Icons.warning_amber_rounded;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _iconColor().withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _iconColor().withValues(alpha: 0.1),
              ),
              child: Icon(
                _icon(),
                size: 18,
                color: _iconColor(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.ink900,
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
