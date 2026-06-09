import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Custom paw print rendered as a vector path.
/// Used for decorative elements, empty states, and loading animation.
class PawPrint extends StatelessWidget {
  final double size;
  final Color? color;
  final double opacity;

  const PawPrint({
    super.key,
    this.size = 24,
    this.color,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final paintColor = (color ?? AppColors.primary).withValues(alpha: opacity);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _PawPrintPainter(paintColor),
      ),
    );
  }
}

class _PawPrintPainter extends CustomPainter {
  final Color color;

  _PawPrintPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final scale = size.width / 100;

    // Main pad
    canvas.drawPath(
      _roundedPath(
        Offset(50 * scale, 55 * scale),
        18 * scale,
        14 * scale,
      ),
      paint,
    );

    // Four toe pads
    for (final offset in [
      Offset(28 * scale, 25 * scale),
      Offset(50 * scale, 15 * scale),
      Offset(72 * scale, 25 * scale),
      Offset(60 * scale, 35 * scale),
    ]) {
      canvas.drawPath(
        _roundedPath(offset, 8 * scale, 12 * scale),
        paint,
      );
    }
  }

  Path _roundedPath(Offset center, double rx, double ry) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
        Radius.circular(rx),
      ));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paw-print walking animation loader.
/// Four paw prints fade in sequence, simulating a pet walking.
class PawPrintLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const PawPrintLoader({
    super.key,
    this.size = 32,
    this.color,
  });

  @override
  State<PawPrintLoader> createState() => _PawPrintLoaderState();
}

class _PawPrintLoaderState extends State<PawPrintLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pawColor = widget.color ?? AppColors.primary;

    return SizedBox(
      width: widget.size * 3,
      height: widget.size * 1.4,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              // Each paw print fades in sequence
              final pawProgress = (_controller.value * 4 - index).clamp(0.0, 1.0);
              final scale = 0.5 + (pawProgress * 0.5);
              final opacity = pawProgress * 0.6;
              final forwardOffset = pawProgress * 4;

              return Transform.translate(
                offset: Offset(forwardOffset, sin(pawProgress * pi) * 3),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity.clamp(0.2, 1.0),
                    child: PawPrint(
                      size: widget.size,
                      color: pawColor,
                      opacity: 0.6,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
