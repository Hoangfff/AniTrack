import 'package:flutter/material.dart';

import '../theme/anitrack_colors.dart';
import '../theme/anitrack_spacing.dart';
import '../theme/anitrack_typography.dart';

/// Badge style variants.
enum AniTrackBadgeVariant {
  /// Generic informational (blue tint).
  info,

  /// Success / positive (green tint).
  success,

  /// Warning (yellow tint).
  warning,

  /// Accent / brand (pink tint).
  accent,

  /// HD quality indicator (solid green).
  hd,

  /// Subtitle count indicator (solid blue).
  sub,

  /// Dub count indicator (solid yellow).
  dub,
}

/// A small pill-shaped badge for metadata display.
///
/// Used for anime metadata like HD quality, sub/dub counts,
/// ratings, genres, etc.
///
/// ```dart
/// AniTrackBadge(label: 'HD', variant: AniTrackBadgeVariant.hd)
/// AniTrackBadge(label: '8', variant: AniTrackBadgeVariant.sub, icon: Icons.subtitles_rounded)
/// ```
class AniTrackBadge extends StatelessWidget {
  const AniTrackBadge({
    super.key,
    required this.label,
    this.variant = AniTrackBadgeVariant.info,
    this.icon,
  });

  final String label;
  final AniTrackBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AniTrackSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AniTrackSpacing.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: _foregroundColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: AniTrackTypography.overline.copyWith(
              color: _foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor => switch (variant) {
    AniTrackBadgeVariant.info => AniTrackColors.info.withOpacity(0.2),
    AniTrackBadgeVariant.success => AniTrackColors.success.withOpacity(0.2),
    AniTrackBadgeVariant.warning => AniTrackColors.warning.withOpacity(0.2),
    AniTrackBadgeVariant.accent => AniTrackColors.primary.withOpacity(0.2),
    AniTrackBadgeVariant.hd => AniTrackColors.badgeHD,
    AniTrackBadgeVariant.sub => AniTrackColors.badgeSub,
    AniTrackBadgeVariant.dub => AniTrackColors.badgeDub,
  };

  Color get _foregroundColor => switch (variant) {
    AniTrackBadgeVariant.info => AniTrackColors.info,
    AniTrackBadgeVariant.success => AniTrackColors.success,
    AniTrackBadgeVariant.warning => AniTrackColors.warning,
    AniTrackBadgeVariant.accent => AniTrackColors.primary,
    AniTrackBadgeVariant.hd ||
    AniTrackBadgeVariant.sub ||
    AniTrackBadgeVariant.dub => AniTrackColors.background,
  };
}
