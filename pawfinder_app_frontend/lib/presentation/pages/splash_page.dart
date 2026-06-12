import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pawController;
  late final Animation<double> _pawAnim;

  @override
  void initState() {
    super.initState();
    _pawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pawAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pawController, curve: Curves.easeInOut),
    );
    _pawController.repeat();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _pawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8612D), // Clay
              Color(0xFFD4541F),
              Color(0xFFC94E1F),
              Color(0xFF5B9A8B), // Sage fade at bottom
            ],
          ),
        ),
        child: Stack(
          children: [
            // Glass overlay panels
            ..._buildGlassAccents(),
            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Paw print logo in glass circle
                  AnimatedBuilder(
                    animation: _pawController,
                    builder: (context, child) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedScale(
                            scale: 0.85 +
                                (_pawAnim.value > 0.5
                                    ? (1.0 - _pawAnim.value) * 0.3
                                    : _pawAnim.value * 0.3),
                            duration: const Duration(milliseconds: 700),
                            child: const Text(
                              '\uD83D\uDC3E',
                              style: TextStyle(fontSize: 44),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'PawFinder',
                    style: AppTypography.displayMedium.copyWith(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reuniting pets with their community',
                    style: AppTypography.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Walking paw dots
                  _PawLoadingDots(controller: _pawController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGlassAccents() {
    return [
      // Top-right glass panel
      Positioned(
        top: -60,
        right: -40,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.04),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
      ),
      // Bottom-left glass panel
      Positioned(
        bottom: -80,
        left: -60,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
        ),
      ),
    ];
  }
}

/// Walking paw-print loading dots
class _PawLoadingDots extends StatelessWidget {
  final AnimationController controller;

  const _PawLoadingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (i) {
            final delay = i * 0.2;
            final value = (controller.value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (value < 0.5 ? value * 1.0 : (1.0 - value) * 1.0);
            final opacity = value < 0.2
                ? value * 5.0
                : value < 0.8
                    ? 1.0
                    : (1.0 - value) * 5.0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Container(
                    width: 12,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
