import 'package:flutter/material.dart';

import '../theme/anitrack_colors.dart';
import '../theme/anitrack_spacing.dart';
import '../theme/anitrack_typography.dart';

/// Button style variants.
enum AniTrackButtonVariant { primary, secondary, outline, ghost }

/// Button size presets.
enum AniTrackButtonSize { small, medium, large }

/// A styled button matching the AniTrack design system.
///
/// Supports four variants (primary, secondary, outline, ghost),
/// three sizes, optional leading icon, loading state, and
/// full-width expansion.
///
/// ```dart
/// AniTrackButton(
///   label: 'Watch Now',
///   icon: Icons.play_arrow_rounded,
///   variant: AniTrackButtonVariant.primary,
///   onPressed: () {},
/// )
/// ```
class AniTrackButton extends StatelessWidget {
  const AniTrackButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AniTrackButtonVariant.primary,
    this.size = AniTrackButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AniTrackButtonVariant variant;
  final AniTrackButtonSize size;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final Widget child = _buildChild();

    late final Widget button;
    switch (variant) {
      case AniTrackButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AniTrackColors.primary,
            foregroundColor: AniTrackColors.onPrimary,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: _borderRadius),
            textStyle: _textStyle,
            elevation: 0,
          ),
          child: child,
        );
      case AniTrackButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AniTrackColors.secondary,
            foregroundColor: AniTrackColors.onPrimary,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: _borderRadius),
            textStyle: _textStyle,
            elevation: 0,
          ),
          child: child,
        );
      case AniTrackButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AniTrackColors.onSurface,
            side: const BorderSide(color: AniTrackColors.borderLight),
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: _borderRadius),
            textStyle: _textStyle,
          ),
          child: child,
        );
      case AniTrackButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AniTrackColors.onSurface,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: _borderRadius),
            textStyle: _textStyle,
          ),
          child: child,
        );
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  // ── Helpers ─────────────────────────────────

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color:
              variant == AniTrackButtonVariant.outline ||
                  variant == AniTrackButtonVariant.ghost
              ? AniTrackColors.onSurface
              : AniTrackColors.onPrimary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize),
          const SizedBox(width: AniTrackSpacing.xs),
          Text(label),
        ],
      );
    }

    return Text(label);
  }

  EdgeInsets get _padding => switch (size) {
    AniTrackButtonSize.small => AniTrackSpacing.paddingButtonSmall,
    AniTrackButtonSize.medium => AniTrackSpacing.paddingButtonMedium,
    AniTrackButtonSize.large => AniTrackSpacing.paddingButtonLarge,
  };

  BorderRadius get _borderRadius => switch (size) {
    AniTrackButtonSize.small => AniTrackSpacing.radiusSmall,
    AniTrackButtonSize.medium => AniTrackSpacing.radiusMedium,
    AniTrackButtonSize.large => AniTrackSpacing.radiusMedium,
  };

  TextStyle get _textStyle => switch (size) {
    AniTrackButtonSize.small => AniTrackTypography.labelSmall,
    AniTrackButtonSize.medium => AniTrackTypography.labelLarge,
    AniTrackButtonSize.large => AniTrackTypography.titleSmall,
  };

  double get _iconSize => switch (size) {
    AniTrackButtonSize.small => 14,
    AniTrackButtonSize.medium => 18,
    AniTrackButtonSize.large => 22,
  };
}
