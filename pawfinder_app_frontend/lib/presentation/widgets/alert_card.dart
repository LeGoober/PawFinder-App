import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'status_badge.dart';

class AlertCard extends StatelessWidget {
  final String petName;
  final String species;
  final String timeMissing;
  final String distance;
  final String? description;
  final double? reward;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const AlertCard({
    super.key,
    required this.petName,
    required this.species,
    required this.timeMissing,
    required this.distance,
    this.description,
    this.reward,
    this.imageUrl,
    this.onTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppSpacing.paddingSm,
      elevation: AppSpacing.statCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhoto(),
              SizedBox(width: AppSpacing.paddingMd.right),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    return Container(
      width: AppSpacing.alertCardImageSize,
      height: AppSpacing.alertCardImageSize,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: Text(
          species == 'Dog' ? '🐕' : '🐈',
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StatusBadge(
              text: species,
              type: StatusType.active,
            ),
            const Spacer(),
            Text(
              timeMissing,
              style: AppTypography.caption,
            ),
          ],
        ),
        AppSpacing.xs,
        Text(petName, style: AppTypography.h3),
        AppSpacing.xs,
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: AppSpacing.iconSmall,
              color: AppColors.ink500,
            ),
            const SizedBox(width: 4),
            Text(
              distance,
              style: AppTypography.bodySmall,
            ),
            if (reward != null) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.rewardLight,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  '\$${reward!.toStringAsFixed(0)} reward',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.rewardDark,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (description != null && description!.isNotEmpty) ...[
          AppSpacing.xs,
          Text(
            description!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.ink700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        AppSpacing.sm,
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            'I Saw This Pet',
            style: AppTypography.button.copyWith(
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
