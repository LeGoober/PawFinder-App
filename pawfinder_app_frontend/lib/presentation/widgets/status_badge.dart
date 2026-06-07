import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum StatusType { active, resolved, pending, verified }

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
  });

  Color _backgroundColor() {
    switch (type) {
      case StatusType.active:
        return AppColors.dangerLight;
      case StatusType.resolved:
        return AppColors.successLight;
      case StatusType.pending:
        return AppColors.rewardLight;
      case StatusType.verified:
        return AppColors.secondaryLight;
    }
  }

  Color _textColor() {
    switch (type) {
      case StatusType.active:
        return AppColors.danger;
      case StatusType.resolved:
        return AppColors.success;
      case StatusType.pending:
        return AppColors.rewardDark;
      case StatusType.verified:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: _textColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
