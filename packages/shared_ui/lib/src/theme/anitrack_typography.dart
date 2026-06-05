import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AniTrack design system typography.
///
/// Uses [Outfit](https://fonts.google.com/specimen/Outfit) — a clean,
/// geometric sans-serif that works great for modern streaming UIs.
///
/// Hierarchy mirrors Material's `TextTheme` naming so it plugs straight
/// into `ThemeData`.
class AniTrackTypography {
  AniTrackTypography._();

  // ──────────────────────────────────────────────
  //  Display — hero / spotlight titles
  // ──────────────────────────────────────────────

  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static TextStyle get displayMedium => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
  );

  static TextStyle get displaySmall => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ──────────────────────────────────────────────
  //  Headline — section headers
  // ──────────────────────────────────────────────

  static TextStyle get headlineLarge => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get headlineSmall => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ──────────────────────────────────────────────
  //  Title — card / list item titles
  // ──────────────────────────────────────────────

  static TextStyle get titleLarge => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get titleMedium => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get titleSmall => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ──────────────────────────────────────────────
  //  Body — paragraph / description text
  // ──────────────────────────────────────────────

  static TextStyle get bodyLarge => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ──────────────────────────────────────────────
  //  Label — buttons, nav items, form labels
  // ──────────────────────────────────────────────

  static TextStyle get labelLarge => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle get labelMedium => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static TextStyle get labelSmall => GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ──────────────────────────────────────────────
  //  Overline — badges, tags, metadata
  // ──────────────────────────────────────────────

  static TextStyle get overline => GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    height: 1.4,
  );

  // ──────────────────────────────────────────────
  //  TextTheme builder
  // ──────────────────────────────────────────────

  /// Returns a complete [TextTheme] using the Outfit font family.
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
