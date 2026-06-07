import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_core/shared_core.dart';

class TrackingAnimeCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TrackingAnimeCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? 'Unknown';
    final imageUrl = data['imageUrl'] ?? '';
    final progress = data['progress'] ?? 0;
    final totalEpisodes = data['totalEpisodes'] ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (data['animeId'] != null) {
            eventBus.fire(AnimeSelectedEvent(data['animeId']));
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AniTrackColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity)
                  : Container(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AniTrackTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tiến độ: $progress / ${totalEpisodes > 0 ? totalEpisodes : '?'}',
                  style: AniTrackTypography.bodySmall.copyWith(color: AniTrackColors.primary),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: totalEpisodes > 0 ? (progress / totalEpisodes) : 0.0,
                  backgroundColor: Colors.grey[800],
                  color: AniTrackColors.primary,
                  minHeight: 4,
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
