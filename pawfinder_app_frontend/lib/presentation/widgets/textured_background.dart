import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Available background modes for the app shell.
enum BackgroundMode {
  /// Original warm paper texture (v2 style)
  paper,
  /// Glass-optimized warm gradient backdrop with noise overlay
  warmGlass,
}

/// A background wrapper that supports both paper-textured and
/// glass-optimized modes.
///
/// [BackgroundMode.warmGlass] provides a subtle warm gradient
/// with noise grain — ideal as the backdrop that shows through
/// glass panels when they blur.
class TexturedBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final BackgroundMode mode;

  const TexturedBackground({
    super.key,
    required this.child,
    this.isDark = false,
    this.mode = BackgroundMode.warmGlass,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark || Theme.of(context).brightness == Brightness.dark;

    switch (mode) {
      case BackgroundMode.warmGlass:
        return _buildWarmGlassBackground(isDarkMode, child);
      case BackgroundMode.paper:
        return _buildPaperBackground(isDarkMode, child);
    }
  }

  Widget _buildWarmGlassBackground(bool dark, Widget content) {
    return Stack(
      children: [
        // Warm gradient base — what shows through the glass blur
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [
                      const Color(0xFF1A1815),
                      const Color(0xFF1F1B17),
                      const Color(0xFF24211D),
                      const Color(0xFF1C1916),
                    ]
                  : [
                      const Color(0xFFFFFBF5),
                      const Color(0xFFFFF8F0),
                      const Color(0xFFFFF5EB),
                      const Color(0xFFFFF8F0),
                    ],
            ),
          ),
        ),
        // Warm ambient glow spots — soft pools of warmth that show through glass
        ..._buildGlowSpots(dark),
        // Subtle noise texture over the gradient
        Positioned.fill(
          child: Opacity(
            opacity: dark ? 0.025 : 0.012,
            child: CustomPaint(
              painter: _NoisePainter(),
            ),
          ),
        ),
        // Content
        content,
      ],
    );
  }

  List<Widget> _buildGlowSpots(bool dark) {
    return [
      // Top-right warm amber glow
      Positioned(
        top: -100,
        right: -80,
        child: Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (dark ? const Color(0xFFF0733D) : const Color(0xFFE8612D))
                    .withValues(alpha: dark ? 0.08 : 0.06),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Bottom-left sage glow
      Positioned(
        bottom: -60,
        left: -60,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (dark ? const Color(0xFF6BAFA0) : const Color(0xFF5B9A8B))
                    .withValues(alpha: dark ? 0.05 : 0.04),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Center subtle warm glow
      Center(
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (dark ? const Color(0xFFF0733D) : const Color(0xFFE8612D))
                    .withValues(alpha: dark ? 0.03 : 0.02),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildPaperBackground(bool dark, Widget content) {
    return Stack(
      children: [
        Container(
          color: dark ? AppColors.paperDark : AppColors.paper,
        ),
        Positioned.fill(
          child: Opacity(
            opacity: dark ? 0.025 : 0.015,
            child: CustomPaint(
              painter: _NoisePainter(),
            ),
          ),
        ),
        content,
      ],
    );
  }

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.ink900;
    final random = Random(42); // Seeded for consistency
    final count = (size.width * size.height * 0.002).toInt();
    for (int i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = random.nextInt(30);
      paint.color = AppColors.ink900.withValues(alpha: alpha / 255.0);
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
