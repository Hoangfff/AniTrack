import 'package:discovery_mfe/src/presentation/widgets/anime_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

class AnimeCard extends StatelessWidget {
  final AnimeModel anime;

  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return AniTrackCard(
      padding: EdgeInsets.zero,
      onTap: () {
        AnimeDetailsModal.show(context, anime);
      },
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: AniTrackSpacing.radiusLarge,
              child: Image.network(
                anime.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AniTrackColors.surfaceVariant,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: AniTrackColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AniTrackSpacing.radiusLarge,
                gradient: const LinearGradient(
                  colors: [Colors.transparent, AniTrackColors.background],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content Box at Bottom
          Positioned(
            left: AniTrackSpacing.sm,
            bottom: AniTrackSpacing.sm,
            right: AniTrackSpacing.sm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  anime.title,
                  style: AniTrackTypography.headlineMedium.copyWith(
                    color: AniTrackColors.onBackground,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AniTrackSpacing.xs),
                Row(
                  children: [
                    if (anime.score > 0)
                      AniTrackBadge(
                        label: anime.score.toString(),
                        variant: AniTrackBadgeVariant.accent,
                        icon: Icons.star_rounded,
                      ),
                    const SizedBox(width: AniTrackSpacing.xs),
                    if (anime.episodes > 0)
                      AniTrackBadge(
                        label: '${anime.episodes} EPS',
                        variant: AniTrackBadgeVariant.info,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
