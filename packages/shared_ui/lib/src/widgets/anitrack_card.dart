import 'package:flutter/material.dart';

import '../theme/anitrack_colors.dart';
import '../theme/anitrack_spacing.dart';

/// A surface card with subtle border and optional hover glow.
///
/// Use as the base container for anime thumbnails, content cards,
/// info panels, etc.
///
/// ```dart
/// AniTrackCard(
///   onTap: () => navigateToDetail(),
///   child: Column(children: [thumbnail, title]),
/// )
/// ```
class AniTrackCard extends StatefulWidget {
  const AniTrackCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.enableHoverEffect = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool enableHoverEffect;

  @override
  State<AniTrackCard> createState() => _AniTrackCardState();
}

class _AniTrackCardState extends State<AniTrackCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enableHoverEffect
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.enableHoverEffect
          ? (_) => setState(() => _isHovered = false)
          : null,
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AniTrackSpacing.animNormal,
          curve: Curves.easeOut,
          padding: widget.padding ?? AniTrackSpacing.paddingCard,
          decoration: BoxDecoration(
            color: AniTrackColors.surface,
            borderRadius: AniTrackSpacing.radiusLarge,
            border: Border.all(
              color: _isHovered
                  ? AniTrackColors.primary.withOpacity(0.4)
                  : AniTrackColors.border,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AniTrackColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
