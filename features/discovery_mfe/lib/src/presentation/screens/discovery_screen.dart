import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

import '../controllers/discovery_controller.dart';
import '../widgets/scrollable_anime_row.dart';
import '../widgets/error_card.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  String _searchQuery = '';
  final JikanRepository _jikanRepo = JikanRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AniTrackColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AniTrackColors.background,
            title: Text(
              'Discovery',
              style: AniTrackTypography.displayMedium.copyWith(
                color: AniTrackColors.onBackground,
              ),
            ),
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AniTrackSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AniTrackSpacing.lg),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm Anime...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AniTrackColors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AniTrackSpacing.lg),

                  if (_searchQuery.isNotEmpty)
                    _buildSearchResults()
                  else ...[
                    _buildSectionHeader('Current Season'),
                    _buildSeasonalAnime(ref),

                    const SizedBox(height: AniTrackSpacing.xl),

                    _buildSectionHeader('Top Anime'),
                    _buildTopAnime(ref),

                    const SizedBox(height: AniTrackSpacing.xl),

                    _buildSectionHeader('Anime By Genre'),
                    _buildAnimeByGenre(ref),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AniTrackSpacing.lg),
      child: Text(
        title,
        style: AniTrackTypography.headlineLarge.copyWith(
          color: AniTrackColors.onBackground,
        ),
      ),
    );
  }

  Widget _buildSeasonalAnime(WidgetRef ref) {
    final seasonalAsync = ref.watch(seasonalAnimeProvider);
    return _buildAsyncRow(
      seasonalAsync,
      onRetry: () => ref.invalidate(seasonalAnimeProvider),
    );
  }

  Widget _buildTopAnime(WidgetRef ref) {
    final topAsync = ref.watch(topAnimeProvider);
    return _buildAsyncRow(
      topAsync,
      onRetry: () => ref.invalidate(topAnimeProvider),
    );
  }

  Widget _buildAnimeByGenre(WidgetRef ref) {
    final genresAsync = ref.watch(animeGenresProvider);

    return genresAsync.when(
      data: (genres) {
        if (genres.isEmpty) return const SizedBox.shrink();

        final selectedGenreId = ref.watch(selectedGenreIdProvider);
        final targetGenreId = selectedGenreId ?? genres.first.id;
        final targetGenre = genres.firstWhere(
          (g) => g.id == targetGenreId,
          orElse: () => genres.first,
        );

        final animeByGenreAsync = ref.watch(
          animeByGenreProvider(targetGenre.id),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AniTrackSpacing.lg,
                vertical: AniTrackSpacing.xs,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  spacing: AniTrackSpacing.sm,
                  children: genres.map((genre) {
                    final isSelected = genre.id == targetGenre.id;
                    return ChoiceChip(
                      label: Text(genre.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedGenreIdProvider.notifier).state =
                              genre.id;
                        }
                      },
                      selectedColor: AniTrackColors.primaryContainer,
                      backgroundColor: AniTrackColors.surfaceVariant,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AniTrackColors.primary
                            : AniTrackColors.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AniTrackSpacing.radiusSmall,
                        side: BorderSide(
                          color: isSelected
                              ? AniTrackColors.primary
                              : Colors.transparent,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: AniTrackSpacing.md),
            _buildAsyncRow(
              animeByGenreAsync,
              onRetry: () =>
                  ref.invalidate(animeByGenreProvider(targetGenre.id)),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(color: AniTrackColors.primary),
        ),
      ),
      error: (err, stack) => ErrorCard(
        message: err.toString(),
        onRetry: () => ref.invalidate(animeGenresProvider),
      ),
    );
  }

  Widget _buildAsyncRow(
    AsyncValue<List<AnimeModel>> asyncValue, {
    VoidCallback? onRetry,
  }) {
    return asyncValue.when(
      data: (animeList) => ScrollableAnimeRow(animeList: animeList),
      loading: () => const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(color: AniTrackColors.primary),
        ),
      ),
      error: (err, stack) =>
          ErrorCard(message: err.toString(), onRetry: onRetry),
    );
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<AnimeModel>>(
      future: _jikanRepo.searchAnime(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator(color: AniTrackColors.primary)),
          );
        }
        if (snapshot.hasError) {
          return const ErrorCard(message: 'Lỗi tìm kiếm');
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const SizedBox(
            height: 280,
            child: Center(child: Text('Không tìm thấy anime.')),
          );
        }
        // Hiển thị dạng cuộn ngang giống ScrollableAnimeRow
        return ScrollableAnimeRow(animeList: list);
      },
    );
  }
}
