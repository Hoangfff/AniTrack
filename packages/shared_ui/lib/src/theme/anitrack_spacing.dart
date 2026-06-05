import 'package:flutter/material.dart';

/// AniTrack design system spacing, radii, and layout constants.
class AniTrackSpacing {
  AniTrackSpacing._();

  // ──────────────────────────────────────────────
  //  Spacing scale (multiples of 4)
  // ──────────────────────────────────────────────

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
  static const double xxxxl = 64.0;

  // ──────────────────────────────────────────────
  //  Border Radius
  // ──────────────────────────────────────────────

  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusXLarge = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(999));

  // ──────────────────────────────────────────────
  //  Common EdgeInsets presets
  // ──────────────────────────────────────────────

  static const EdgeInsets paddingCard = EdgeInsets.all(md);
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );
  static const EdgeInsets paddingSection = EdgeInsets.symmetric(vertical: xxl);

  static const EdgeInsets paddingButtonSmall = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );
  static const EdgeInsets paddingButtonMedium = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
  static const EdgeInsets paddingButtonLarge = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  // ──────────────────────────────────────────────
  //  Sidebar dimensions
  // ──────────────────────────────────────────────

  static const double sidebarExpanded = 240.0;
  static const double sidebarCollapsed = 72.0;

  // ──────────────────────────────────────────────
  //  Animation durations
  // ──────────────────────────────────────────────

  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 400);
}
