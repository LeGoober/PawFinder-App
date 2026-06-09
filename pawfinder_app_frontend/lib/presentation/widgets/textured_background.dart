import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A subtle paper-texture background that wraps the app content.
/// Applies a barely-perceptible noise grain over the warm paper color.
class TexturedBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const TexturedBackground({
    super.key,
    required this.child,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark || Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base color
        Container(
          color: isDarkMode ? AppColors.paperDark : AppColors.paper,
        ),
        // Subtle noise texture
        Positioned.fill(
          child: Opacity(
            opacity: isDarkMode ? 0.025 : 0.015,
            child: CustomPaint(
              painter: _NoisePainter(),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
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
