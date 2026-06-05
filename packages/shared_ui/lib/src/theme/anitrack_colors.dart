import 'package:flutter/material.dart';

/// AniTrack design system color palette.
///
/// Dark-first palette inspired by modern anime streaming UIs.
/// Use these constants throughout the app for consistent theming.
class AniTrackColors {
  AniTrackColors._();

  // ──────────────────────────────────────────────
  //  Backgrounds
  // ──────────────────────────────────────────────

  /// Deepest background — used for the main scaffold.
  static const Color background = Color(0xFF0D0D1A);

  /// Default surface — cards, sidebar, elevated containers.
  static const Color surface = Color(0xFF1A1A2E);

  /// Subtle surface variant — input fields, inset panels.
  static const Color surfaceVariant = Color(0xFF16213E);

  /// Elevated surface — tooltips, dropdowns, popovers.
  static const Color surfaceElevated = Color(0xFF1E2A45);

  /// Semi-transparent overlay for modals / drawers.
  static const Color overlay = Color(0x80000000);

  // ──────────────────────────────────────────────
  //  Primary — Pink / Rose
  // ──────────────────────────────────────────────

  static const Color primary = Color(0xFFFF6B9D);
  static const Color primaryLight = Color(0xFFFF8DC0);
  static const Color primaryDark = Color(0xFFE04E80);
  static const Color primaryContainer = Color(0x33FF6B9D);

  // ──────────────────────────────────────────────
  //  Secondary — Purple / Violet
  // ──────────────────────────────────────────────

  static const Color secondary = Color(0xFF7C5CFC);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF5B3FD9);
  static const Color secondaryContainer = Color(0x337C5CFC);

  // ──────────────────────────────────────────────
  //  Tertiary — Teal / Cyan
  // ──────────────────────────────────────────────

  static const Color tertiary = Color(0xFF00D4AA);
  static const Color tertiaryContainer = Color(0x3300D4AA);

  // ──────────────────────────────────────────────
  //  Semantic
  // ──────────────────────────────────────────────

  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  // ──────────────────────────────────────────────
  //  Text
  // ──────────────────────────────────────────────

  /// High-emphasis text on dark backgrounds.
  static const Color onBackground = Color(0xFFFFFFFF);

  /// Default text on surface containers.
  static const Color onSurface = Color(0xFFE2E8F0);

  /// Text on primary-colored backgrounds.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Subdued, secondary text.
  static const Color textMuted = Color(0xFF94A3B8);

  /// Disabled / placeholder text.
  static const Color textDisabled = Color(0xFF475569);

  // ──────────────────────────────────────────────
  //  Badges (anime metadata)
  // ──────────────────────────────────────────────

  static const Color badgeHD = Color(0xFF4ADE80);
  static const Color badgeSub = Color(0xFF38BDF8);
  static const Color badgeDub = Color(0xFFFBBF24);
  static const Color badgeRating = Color(0xFFFF6B9D);

  // ──────────────────────────────────────────────
  //  Borders
  // ──────────────────────────────────────────────

  static const Color border = Color(0xFF2A2A4A);
  static const Color borderLight = Color(0xFF3A3A5A);
}
