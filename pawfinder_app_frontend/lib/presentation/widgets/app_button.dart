import 'package:flutter/material.dart';
import 'package:pawfinder_app/core/theme/app_colors.dart';
import 'package:pawfinder_app/core/theme/app_typography.dart';

enum AppButtonType { primary, secondary, success, danger, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(12));
  static const _height = 56.0;
  static const _hPad = 24.0;
  static const _smGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final fgColor = _foregroundColor();

    if (isLoading) {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: _height,
        child: ElevatedButton(
          onPressed: null,
          style: _buttonStyle(fgColor),
          child: const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      );
    }

    final Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: fgColor),
          const SizedBox(width: _smGap),
        ],
        Flexible(
          child: Text(
            text,
            style: AppTypography.textTheme.labelLarge?.copyWith(color: fgColor),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _height,
      child: type == AppButtonType.text
          ? TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
              ),
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: _buttonStyle(fgColor),
              child: buttonChild,
            ),
    );
  }

  ButtonStyle _buttonStyle(Color fgColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: _backgroundColor(),
      foregroundColor: fgColor,
      elevation: type == AppButtonType.text ? 0 : 1,
      shadowColor: AppColors.ink900.withAlpha(25),
      shape: const RoundedRectangleBorder(
        borderRadius: _borderRadius,
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: _hPad),
    ).copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        if (type == AppButtonType.secondary) {
          return const BorderSide(color: AppColors.ink300, width: 1.5);
        }
        return BorderSide.none;
      }),
    );
  }

  Color _backgroundColor() => switch (type) {
    AppButtonType.primary => AppColors.primary,
    AppButtonType.secondary => Colors.transparent,
    AppButtonType.success => AppColors.success,
    AppButtonType.danger => AppColors.danger,
    AppButtonType.text => Colors.transparent,
  };

  Color _foregroundColor() => switch (type) {
    AppButtonType.primary => Colors.white,
    AppButtonType.secondary => AppColors.ink900,
    AppButtonType.success => Colors.white,
    AppButtonType.danger => Colors.white,
    AppButtonType.text => AppColors.primary,
  };
}
