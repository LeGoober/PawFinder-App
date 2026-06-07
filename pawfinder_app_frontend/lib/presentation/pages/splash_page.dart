import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PawFinder',
              style: AppTypography.displayLarge.copyWith(
                color: AppColors.background,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Reuniting pets with their community',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.background.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
