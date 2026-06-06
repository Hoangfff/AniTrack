import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../models/episode_model.dart';

class AnikotoRepository {
  final Dio _client = ApiClient().anikotoClient;

  Future<List<EpisodeModel>> getEpisodesList(String animeId) async {
    final response = await _client.get('/anime/$animeId/episodes');
    final data = response.data['episodes'] as List<dynamic>? ?? [];
    return data.map((e) => EpisodeModel.fromJson(e)).toList();
  }
}
