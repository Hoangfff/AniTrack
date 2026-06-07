// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:player_mfe/src/controllers/player_controller.dart';

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class AnimePlayerScreen extends ConsumerStatefulWidget {
  final int? malId;

  const AnimePlayerScreen({super.key, this.malId});

  @override
  ConsumerState<AnimePlayerScreen> createState() => _AnimePlayerScreenState();
}

class _AnimePlayerScreenState extends ConsumerState<AnimePlayerScreen> {
  late String _viewType = '';

  @override
  void initState() {
    super.initState();
    html.window.onMessage.listen(_onMessageReceived);
  }

  void _setupIframe(int episodeNumber, String language) {
    if (widget.malId == null) return;

    _viewType = 'megaplay-iframe-${widget.malId}-$episodeNumber-$language';

    final embedUrl = MegaPlayHelper.generateEmbedUrl(
      malId: widget.malId!,
      episodeNumber: episodeNumber,
      lang: language,
    );

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = embedUrl
        ..style.border = 'none'
        ..allowFullscreen = true;
      return iframe;
    });
  }

  void _onMessageReceived(html.MessageEvent event) {
    try {
      if (event.data is String) {
        final data = jsonDecode(event.data);
        if (data['event'] == 'complete') {
          final episodeNumber = ref.read(selectedEpisodeProvider);
          eventBus.fire(
            VideoCompletedEvent(widget.malId.toString(), episodeNumber),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Episode finished sync successfully!'),
                backgroundColor: AniTrackColors.success,
              ),
            );
          }
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.malId == null) {
      return const Scaffold(
        backgroundColor: AniTrackColors.background,
        body: Center(
          child: Text(
            'No anime selected.',
            style: TextStyle(color: AniTrackColors.textMuted),
          ),
        ),
      );
    }

    final episodesAsync = ref.watch(
      animeEpisodesProvider(widget.malId.toString()),
    );
    final currentEpisode = ref.watch(selectedEpisodeProvider);
    final currentLanguage = ref.watch(playerLanguageProvider);

    _setupIframe(currentEpisode, currentLanguage);

    return Scaffold(
      backgroundColor: AniTrackColors.background,
      body: Row(
        children: [
          // Main Player Area
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: HtmlElementView(viewType: _viewType),
                ),
              ),
            ),
          ),

          // Right Sidebar Options
          Container(
            width: 380,
            decoration: const BoxDecoration(
              color: AniTrackColors.surface,
              border: Border(left: BorderSide(color: AniTrackColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header / Sub-Dub Toggle
                Padding(
                  padding: const EdgeInsets.all(AniTrackSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information',
                        style: AniTrackTypography.headlineMedium.copyWith(
                          color: AniTrackColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: AniTrackSpacing.md),
                      episodesAsync.when(
                        data: (episodes) {
                          if (episodes.isEmpty) {
                            return const Center(
                              child: Text(
                                'No information available.',
                                style: TextStyle(
                                  color: AniTrackColors.textMuted,
                                ),
                              ),
                            );
                          }

                          final currentEp = episodes.firstWhere(
                            (ep) => ep.id == currentEpisode.toString(),
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Current Episode: ',
                                      style: AniTrackTypography.titleSmall
                                          .copyWith(
                                            color: AniTrackColors.onSurface,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${currentEp.title} / ${currentEp.titleJapanese} / ${currentEp.titleRomanji}',
                                      style: AniTrackTypography.bodyMedium
                                          .copyWith(
                                            color: AniTrackColors.textMuted,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AniTrackSpacing.xs),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Score: ★ ',
                                      style: AniTrackTypography.titleSmall
                                          .copyWith(
                                            color: AniTrackColors.onSurface,
                                          ),
                                    ),
                                    TextSpan(
                                      text: currentEp.score > 0
                                          ? currentEp.score.toString()
                                          : 'N/A',
                                      style: AniTrackTypography.bodyMedium
                                          .copyWith(
                                            color: AniTrackColors.textMuted,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AniTrackSpacing.xs),
                              Row(
                                children: [
                                  AniTrackBadge(
                                    label: 'HD',
                                    variant: AniTrackBadgeVariant.accent,
                                  ),
                                  const SizedBox(width: AniTrackSpacing.xs),
                                  AniTrackBadge(
                                    label: 'SUB / DUB',
                                    variant: AniTrackBadgeVariant.info,
                                  ),
                                  const SizedBox(width: AniTrackSpacing.xs),
                                ],
                              ),
                            ],
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AniTrackColors.primary,
                          ),
                        ),
                        error: (e, _) => Center(
                          child: Text(
                            'Failed to load information',
                            style: TextStyle(color: AniTrackColors.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: AniTrackColors.borderLight, height: 1),

                Padding(
                  padding: const EdgeInsets.all(AniTrackSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Options',
                        style: AniTrackTypography.headlineMedium.copyWith(
                          color: AniTrackColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AniTrackSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Sub')),
                              selected: currentLanguage == 'sub',
                              onSelected: (val) {
                                if (val)
                                  ref
                                          .read(playerLanguageProvider.notifier)
                                          .state =
                                      'sub';
                              },
                              selectedColor: AniTrackColors.primary,
                              labelStyle: TextStyle(
                                color: currentLanguage == 'sub'
                                    ? AniTrackColors.onPrimary
                                    : AniTrackColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: AniTrackColors.surfaceVariant,
                            ),
                          ),
                          const SizedBox(width: AniTrackSpacing.sm),
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Dub')),
                              selected: currentLanguage == 'dub',
                              onSelected: (val) {
                                if (val)
                                  ref
                                          .read(playerLanguageProvider.notifier)
                                          .state =
                                      'dub';
                              },
                              selectedColor: AniTrackColors.primary,
                              labelStyle: TextStyle(
                                color: currentLanguage == 'dub'
                                    ? AniTrackColors.onPrimary
                                    : AniTrackColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: AniTrackColors.surfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(color: AniTrackColors.borderLight, height: 1),

                // Episodes Grid
                Padding(
                  padding: const EdgeInsets.all(AniTrackSpacing.md),
                  child: Text(
                    'Episodes',
                    style: AniTrackTypography.headlineMedium.copyWith(
                      color: AniTrackColors.onSurface,
                    ),
                  ),
                ),

                Expanded(
                  child: episodesAsync.when(
                    data: (episodes) {
                      if (episodes.isEmpty) {
                        return const Center(
                          child: Text(
                            'No episodes found.',
                            style: TextStyle(color: AniTrackColors.textMuted),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AniTrackSpacing.md,
                          vertical: AniTrackSpacing.xs,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: AniTrackSpacing.xs,
                              mainAxisSpacing: AniTrackSpacing.xs,
                            ),
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          final ep = episodes[index];
                          final isSelected = ep.id == currentEpisode.toString();

                          return InkWell(
                            onTap: () {
                              ref.read(selectedEpisodeProvider.notifier).state =
                                  int.parse(ep.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AniTrackColors.secondary
                                    : AniTrackColors.surfaceVariant,
                                borderRadius: AniTrackSpacing.radiusSmall,
                              ),
                              child: Center(
                                child: Text(
                                  ep.id,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AniTrackColors.onPrimary
                                        : AniTrackColors.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AniTrackColors.primary,
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Text(
                        'Failed to load episodes',
                        style: TextStyle(color: AniTrackColors.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
