import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary: Warm Clay ──
  static const Color primary = Color(0xFFE8612D);
  static const Color primaryDark = Color(0xFFC94E1F);
  static const Color primaryLight = Color(0xFFFFF0E8);

  // ── Secondary: Calm Sage ──
  static const Color secondary = Color(0xFF5B9A8B);
  static const Color secondaryDark = Color(0xFF457A6E);
  static const Color secondaryLight = Color(0xFFEBF5F2);

  // ── Semantic ──
  static const Color success = Color(0xFF4CAF83);
  static const Color successLight = Color(0xFFEDF7F1);
  static const Color danger = Color(0xFFE0554A);
  static const Color dangerLight = Color(0xFFFDF0EE);
  static const Color reward = Color(0xFFE8A840);
  static const Color rewardLight = Color(0xFFFFF8ED);

  // ── Surface: Warm Paper ──
  static const Color paper = Color(0xFFFFFBF5);
  static const Color card = Color(0xFFFFF5EB);
  static const Color cardHover = Color(0xFFFFEFDF);
  static const Color overlay = Color(0xFFFFF0E3);

  // ── Dark Mode Surfaces ──
  static const Color paperDark = Color(0xFF1A1815);
  static const Color cardDark = Color(0xFF24211D);
  static const Color overlayDark = Color(0xFF2D2925);

  // ── Ink: Warm Text ──
  static const Color ink900 = Color(0xFF2D241F);
  static const Color ink700 = Color(0xFF6B5F57);
  static const Color ink500 = Color(0xFF9C9088);

  // ── Dark Mode Text ──
  static const Color ink900Dark = Color(0xFFF5F0E8);
  static const Color ink700Dark = Color(0xFFB8AFA5);
  static const Color ink500Dark = Color(0xFF7A726A);

  // ── Borders ──
  static const Color border = Color(0xFFE8E0D8);
  static const Color borderFocus = Color(0xFFE8612D);
  static const Color divider = Color(0xFFF0E8E0);

  // ── Dark Mode Accents ──
  static const Color primaryDarkMode = Color(0xFFF0733D);
  static const Color secondaryDarkMode = Color(0xFF6BAFA0);

  // ── Backward-compatible aliases (v1 → v2 migration) ──
  static const Color background = paper;
  static const Color surface = card;
  static const Color ink100 = border;
  static const Color ink300 = border;
  static const Color rewardDark = reward;
}
