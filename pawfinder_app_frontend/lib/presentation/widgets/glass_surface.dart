import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A glassmorphic surface panel with warm amber undertones.
///
/// Uses [BackdropFilter] with [ui.ImageFilter.blur] to create
/// a frosted-glass effect. The warmth comes from a subtle clay-tinted
/// gradient overlay and soft white borders.
///
/// [intensity] controls the blur sigma (default 10 → light frost, 20 → heavy glass).
/// [elevation] adds a directional warm shadow (0 = flat glass).
class GlassSurface extends StatelessWidget {
  final Widget? child;
  final double blurSigma;
  final double borderRadius;
  final double elevation;
  final Color? tint;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Gradient? customGradient;
  final bool isDark;

  const GlassSurface({
    super.key,
    this.child,
    this.blurSigma = 12.0,
    this.borderRadius = 24.0,
    this.elevation = 4.0,
    this.tint,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.customGradient,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = isDark || Theme.of(context).brightness == Brightness.dark;
    final bg = tint ?? (dark ? AppColors.glassBgDark : AppColors.glassBg);
    final border = dark ? AppColors.glassBorderDark : AppColors.glassBorder;
    final highlight = dark ? AppColors.glassHighlightDark : AppColors.glassHighlight;
    final shadow = dark ? AppColors.glassShadowDark : AppColors.glassShadow;
    final blurTint = dark ? AppColors.glassBlurTintDark : AppColors.glassBlurTint;

    return Container(
      width: width,
      height: height,
      margin: margin,
      constraints: constraints,
      child: Stack(
        children: [
          // Directional warm shadow (behind the glass)
          if (elevation > 0)
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.only(top: elevation, left: elevation * 0.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: shadow,
                      blurRadius: elevation * 3,
                      offset: Offset(0, elevation * 0.5),
                    ),
                  ],
                ),
              ),
            ),
          // The glass panel
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  // Warm gradient overlay over the blurred background
                  gradient: customGradient ??
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          highlight,
                          bg,
                          blurTint,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                  border: Border.all(
                    color: border,
                    width: 1.0,
                  ),
                ),
                padding: padding,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A simpler glass card variant — thinner glass, smaller radius, optimized for lists.
class GlassCard extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final double borderRadius;

  const GlassCard({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.blurSigma = 8.0,
    this.borderRadius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GlassSurface(
        blurSigma: blurSigma,
        borderRadius: borderRadius,
        elevation: 3.0,
        padding: padding ?? const EdgeInsets.all(16),
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        customGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dark
                ? AppColors.glassHighlightDark
                : AppColors.glassHighlight,
            dark ? AppColors.glassBgDark : AppColors.glassBg,
            dark ? AppColors.glassBlurTintDark : AppColors.glassBlurTint,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        isDark: dark,
        child: child,
      ),
    );
  }
}

/// A glass-bottom navigation bar surface — dense blur, no shadow.
class GlassNavSurface extends StatelessWidget {
  final Widget child;

  const GlassNavSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                dark
                    ? AppColors.glassBgDark
                    : AppColors.paper.withValues(alpha: 0.45),
                dark
                    ? AppColors.paperDark.withValues(alpha: 0.75)
                    : AppColors.paper.withValues(alpha: 0.85),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: dark ? AppColors.glassBorderDark : AppColors.glassBorder,
                width: 0.5,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
