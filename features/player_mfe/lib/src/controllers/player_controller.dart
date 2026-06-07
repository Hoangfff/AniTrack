import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

final jikanRepositoryProvider = Provider<JikanRepository>((ref) {
  return JikanRepository();
});

final animeEpisodesProvider =
    FutureProvider.family<List<JikanEpisodeModel>, String>((
      ref,
      animeId,
    ) async {
      final repo = ref.watch(jikanRepositoryProvider);
      return repo.getEpisodesList(animeId);
    });

// Provides the currently selected episode number
final selectedEpisodeProvider = StateProvider<int>((ref) => 1);

// Provides the current language (sub / dub)
final playerLanguageProvider = StateProvider<String>((ref) => 'sub');
