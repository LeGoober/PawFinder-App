import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext].
extension BuildContextX on BuildContext {
  /// Shorthand for `Theme.of(this)`.
  ThemeData get theme => Theme.of(this);

  /// Shorthand for `Theme.of(this).textTheme`.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Shorthand for `Theme.of(this).colorScheme`.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Shorthand for `MediaQuery.of(this)`.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns `true` when the current [Brightness] is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// Convenience extensions on [String].
extension StringX on String {
  /// Whether this string matches a basic email pattern.
  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  /// Whether this string matches a basic phone-number pattern (7–15 digits,
  /// optional + prefix).
  bool get isValidPhone =>
      RegExp(r'^\+?[\d\s\-()]{7,15}$').hasMatch(this);

  /// Capitalizes the first character of the string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns at most the first two uppercase initials from the string.
  /// "John Doe" → "JD", "alice" → "A", "" → "".
  String get initials {
    final trimmed = trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    return parts
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }
}

/// Convenience extensions on [DateTime].
extension DateTimeX on DateTime {
  /// Returns a human-readable "time ago" string relative to the current
  /// moment, e.g. "2 hours ago", "3 days ago", "Just now".
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays < 30) {
      final d = diff.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    } else if (diff.inDays < 365) {
      final mo = (diff.inDays / 30).floor();
      return '$mo ${mo == 1 ? 'month' : 'months'} ago';
    } else {
      final y = (diff.inDays / 365).floor();
      return '$y ${y == 1 ? 'year' : 'years'} ago';
    }
  }
}
