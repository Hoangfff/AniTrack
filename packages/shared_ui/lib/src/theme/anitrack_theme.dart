import 'package:flutter/material.dart';

import 'anitrack_colors.dart';
import 'anitrack_spacing.dart';
import 'anitrack_typography.dart';

/// Builds complete [ThemeData] instances from AniTrack design tokens.
class AniTrackTheme {
  AniTrackTheme._();

  /// The dark theme — primary theme for the app.
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AniTrackColors.background,

      // ── Color Scheme ──────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: AniTrackColors.primary,
        primaryContainer: AniTrackColors.primaryContainer,
        secondary: AniTrackColors.secondary,
        secondaryContainer: AniTrackColors.secondaryContainer,
        tertiary: AniTrackColors.tertiary,
        tertiaryContainer: AniTrackColors.tertiaryContainer,
        surface: AniTrackColors.surface,
        error: AniTrackColors.error,
        onPrimary: AniTrackColors.onPrimary,
        onSecondary: AniTrackColors.onPrimary,
        onSurface: AniTrackColors.onSurface,
        onError: AniTrackColors.onPrimary,
        outline: AniTrackColors.border,
        outlineVariant: AniTrackColors.borderLight,
      ),

      // ── Typography ────────────────────────────
      textTheme: AniTrackTypography.textTheme.apply(
        bodyColor: AniTrackColors.onSurface,
        displayColor: AniTrackColors.onBackground,
      ),

      // ── AppBar ────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AniTrackColors.surface,
        foregroundColor: AniTrackColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AniTrackTypography.titleLarge.copyWith(
          color: AniTrackColors.onBackground,
        ),
      ),

      // ── Card ──────────────────────────────────
      cardTheme: CardThemeData(
        color: AniTrackColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AniTrackSpacing.radiusLarge,
          side: const BorderSide(color: AniTrackColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton ────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AniTrackColors.primary,
          foregroundColor: AniTrackColors.onPrimary,
          elevation: 0,
          padding: AniTrackSpacing.paddingButtonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AniTrackSpacing.radiusMedium,
          ),
          textStyle: AniTrackTypography.labelLarge,
        ),
      ),

      // ── OutlinedButton ────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AniTrackColors.onSurface,
          side: const BorderSide(color: AniTrackColors.border),
          padding: AniTrackSpacing.paddingButtonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AniTrackSpacing.radiusMedium,
          ),
          textStyle: AniTrackTypography.labelLarge,
        ),
      ),

      // ── TextButton ────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AniTrackColors.primary,
          padding: AniTrackSpacing.paddingButtonSmall,
          textStyle: AniTrackTypography.labelLarge,
        ),
      ),

      // ── IconButton ────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AniTrackColors.onSurface),
      ),

      // ── Input / TextField ─────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AniTrackColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: AniTrackSpacing.radiusMedium,
          borderSide: const BorderSide(color: AniTrackColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AniTrackSpacing.radiusMedium,
          borderSide: const BorderSide(color: AniTrackColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AniTrackSpacing.radiusMedium,
          borderSide: const BorderSide(color: AniTrackColors.primary, width: 2),
        ),
        hintStyle: AniTrackTypography.bodyMedium.copyWith(
          color: AniTrackColors.textMuted,
        ),
        contentPadding: AniTrackSpacing.paddingButtonMedium,
      ),

      // ── Divider ───────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AniTrackColors.border,
        thickness: 1,
        space: 0,
      ),

      // ── Tooltip ───────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AniTrackColors.surfaceElevated,
          borderRadius: AniTrackSpacing.radiusSmall,
          border: Border.all(color: AniTrackColors.border),
        ),
        textStyle: AniTrackTypography.bodySmall.copyWith(
          color: AniTrackColors.onSurface,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),

      // ── Switch ────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AniTrackColors.primary;
          }
          return AniTrackColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AniTrackColors.primaryContainer;
          }
          return AniTrackColors.surfaceVariant;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return AniTrackColors.border;
        }),
      ),
    );
  }

  /// Light theme stub — currently returns the dark theme.
  static ThemeData lightTheme() {
    // TODO: Implement light theme when needed.
    return darkTheme();
  }
}
