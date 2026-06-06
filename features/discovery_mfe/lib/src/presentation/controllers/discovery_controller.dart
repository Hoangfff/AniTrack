import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

final jikanRepositoryProvider = Provider<JikanRepository>((ref) {
  return JikanRepository();
});

final seasonalAnimeProvider = FutureProvider<List<AnimeModel>>((ref) async {
  final repo = ref.watch(jikanRepositoryProvider);
  return repo.getSeasonalAnime();
});

final topAnimeProvider = FutureProvider<List<AnimeModel>>((ref) async {
  final repo = ref.watch(jikanRepositoryProvider);
  return repo.getTopAnime();
});

final animeGenresProvider = FutureProvider<List<GenreModel>>((ref) async {
  final repo = ref.watch(jikanRepositoryProvider);
  return repo.getAnimeGenres();
});

final animeByGenreProvider = FutureProvider.family<List<AnimeModel>, int>((ref, genreId) async {
  final repo = ref.watch(jikanRepositoryProvider);
  return repo.getAnimeByGenre(genreId);
});

final selectedGenreIdProvider = StateProvider<int?>((ref) => null);
