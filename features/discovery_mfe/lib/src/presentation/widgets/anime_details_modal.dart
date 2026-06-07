import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

class AnimeDetailsModal extends ConsumerWidget {
  final AnimeModel anime;

  const AnimeDetailsModal({super.key, required this.anime});

  /// Helper helper static method to easily present the screen cleanly as a dialog
  static void show(BuildContext context, AnimeModel anime) {
    showDialog(
      context: context,
      barrierColor: AniTrackColors.overlay,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        child: AnimeDetailsModal(anime: anime),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height * 0.75,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AniTrackColors.surface,
        borderRadius: AniTrackSpacing.radiusXLarge,
        border: Border.all(color: AniTrackColors.border, width: 1),
      ),
      child: Stack(
        children: [
          // LAYER 1: Right-Aligned Hero Banner Image
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.55,
              heightFactor: 1.0,
              child: anime.imageUrl.isNotEmpty
                  ? Image.network(
                      anime.imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // LAYER 2: Linear Gradient Fade Overlay (Fades right-side cover photo into left background)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AniTrackColors.surface,
                    AniTrackColors.surface.withOpacity(0.9),
                    AniTrackColors.surface.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.45, 0.55, 0.75, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // LAYER 3: Main Left-Hand Metadata Content Layout
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AniTrackSpacing.xs,
                AniTrackSpacing.xxxxl,
                AniTrackSpacing.xxxxl,
                AniTrackSpacing.xxxxl,
              ),
              child: FractionallySizedBox(
                widthFactor: 0.48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Metadata Badges Row (HD, Rating, Status)
                    Row(
                      children: [
                        _buildBadge('HD', AniTrackColors.badgeHD),
                        const SizedBox(width: AniTrackSpacing.xs),
                        _buildBadge('SUB / DUB', AniTrackColors.badgeSub),
                        const SizedBox(width: AniTrackSpacing.xs),
                        _buildBadge(
                          '★ ${anime.score.toStringAsFixed(1)}',
                          AniTrackColors.badgeRating,
                        ),
                        const SizedBox(width: AniTrackSpacing.xs),
                        if (anime.status.isNotEmpty)
                          _buildBadge(
                            anime.status.toUpperCase(),
                            AniTrackColors.textMuted,
                          ),
                      ],
                    ),
                    const SizedBox(height: AniTrackSpacing.md),

                    // Anime Title Text
                    Text(
                      anime.title,
                      style: AniTrackTypography.displayMedium.copyWith(
                        color: AniTrackColors.onBackground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AniTrackSpacing.sm),

                    // Dynamic Genres list mapping
                    if (anime.genres.isNotEmpty) ...[
                      Text(
                        anime.genres.map((g) => g.name).join(' • '),
                        style: AniTrackTypography.labelMedium.copyWith(
                          color: AniTrackColors.primary,
                        ),
                      ),
                      const SizedBox(height: AniTrackSpacing.xl),
                    ],

                    // Synopsis / Summary Text
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          anime.synopsis.isNotEmpty
                              ? anime.synopsis
                              : 'No synopsis available for this title.',
                          style: AniTrackTypography.bodyMedium.copyWith(
                            color: AniTrackColors.onSurface,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AniTrackSpacing.xxl),

                    // Interactive Call To Action Buttons Row
                    Row(
                      children: [
                        // Watch Now Button Action
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Automatically add to tracking
                            await TrackingRepository().addAnimeToList(anime, 'Watching');
                            eventBus.fire(ListUpdatedEvent());

                            // 1. Close detail window
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }

                            // 2. Fire event to change tab and update active anime
                            eventBus.fire(AnimeSelectedEvent(anime.id));
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 24),
                          label: const Text('Watch Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AniTrackColors.primary,
                            foregroundColor: AniTrackColors.onPrimary,
                            padding: AniTrackSpacing.paddingButtonLarge,
                            textStyle: AniTrackTypography.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AniTrackSpacing.md),

                        // Secondary Add to Watchlist / Back Button
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, size: 20),
                          label: const Text('Close'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AniTrackColors.onSurface,
                            side: const BorderSide(
                              color: AniTrackColors.border,
                            ),
                            padding: AniTrackSpacing.paddingButtonLarge,
                            textStyle: AniTrackTypography.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AniTrackSpacing.md),
                        
                        // Add to Tracking List Button
                        IconButton(
                          onPressed: () {
                            eventBus.fire(ShowAddToListDialogEvent(anime));
                          },
                          icon: const Icon(Icons.bookmark_add_outlined),
                          color: AniTrackColors.primary,
                          tooltip: 'Thêm vào Danh sách',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AniTrackSpacing.sm,
        vertical: AniTrackSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: AniTrackSpacing.radiusSmall,
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: AniTrackTypography.overline.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
