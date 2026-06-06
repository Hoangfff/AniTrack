import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorCard({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AniTrackSpacing.lg),
      child: AniTrackCard(
        padding: const EdgeInsets.all(AniTrackSpacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AniTrackColors.error,
                size: 48,
              ),
              const SizedBox(height: AniTrackSpacing.md),
              Text(
                'Oops! Something went wrong',
                style: AniTrackTypography.headlineMedium.copyWith(
                  color: AniTrackColors.onSurface,
                ),
              ),
              const SizedBox(height: AniTrackSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AniTrackTypography.bodyMedium.copyWith(
                  color: AniTrackColors.textMuted,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AniTrackSpacing.xl),
                AniTrackButton(
                  label: 'Retry',
                  icon: Icons.refresh_rounded,
                  variant: AniTrackButtonVariant.outline,
                  onPressed: onRetry,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
