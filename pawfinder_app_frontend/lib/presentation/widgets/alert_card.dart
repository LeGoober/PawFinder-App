import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'glass_surface.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GlassSurface(
        blurSigma: 8,
        borderRadius: 20,
        elevation: 3,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            highlightColor: AppColors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPhoto(),
                  const SizedBox(width: 14),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.secondary.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          species == 'Dog' ? '\uD83D\uDC15' : '\uD83D\uDC08',
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            StatusBadge(
              text: 'MISSING',
              type: StatusType.active,
            ),
            const SizedBox(width: 8),
            Text(
              timeMissing,
              style: AppTypography.caption,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(petName, style: AppTypography.h3),
        const SizedBox(height: 4),
        Text(
          species,
          style: AppTypography.bodySmall.copyWith(color: AppColors.ink500),
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            description!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.ink700,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 14,
              color: AppColors.ink500,
            ),
            const SizedBox(width: 4),
            Text(
              distance,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (reward != null) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.reward.withValues(alpha: 0.15),
                      AppColors.reward.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Text(
                  '\$${reward!.toStringAsFixed(0)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.reward,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const Spacer(),
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                'I Saw This Pet \u2192',
                style: AppTypography.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
