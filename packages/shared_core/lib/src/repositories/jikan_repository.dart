import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../models/anime_model.dart';
import '../models/genre_model.dart';

class JikanRepository {
  final Dio _client = ApiClient().jikanClient;
  List<GenreModel>? _cachedGenres;

  Future<List<AnimeModel>> getSeasonalAnime() async {
    final response = await _client.get('/seasons/now');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => AnimeModel.fromJson(e)).toList();
  }

  Future<List<AnimeModel>> getTopAnime() async {
    final response = await _client.get('/top/anime');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => AnimeModel.fromJson(e)).toList();
  }

  Future<List<AnimeModel>> searchAnime(String keyword) async {
    final response = await _client.get('/anime', queryParameters: {'q': keyword, 'sfw': true});
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => AnimeModel.fromJson(e)).toList();
  }

  Future<AnimeModel> getAnimeDetails(int id) async {
    final response = await _client.get('/anime/$id');
    return AnimeModel.fromJson(response.data['data']);
  }

  Future<List<GenreModel>> getAnimeGenres() async {
    if (_cachedGenres != null) {
      return _cachedGenres!;
    }
    final response = await _client.get('/genres/anime');
    final data = response.data['data'] as List<dynamic>? ?? [];
    _cachedGenres = data.map((e) => GenreModel.fromJson(e)).toList();
    return _cachedGenres!;
  }
}
