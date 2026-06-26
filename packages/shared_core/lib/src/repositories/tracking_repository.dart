import 'package:shared_preferences/shared_preferences.dart';
import '../models/anime_model.dart';
import '../network/api_client.dart';

class TrackingRepository {
  Future<List<String>> getCustomLists() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return [];

    try {
      final response = await ApiClient().localClient.get('/lists/$userId');
      final data = response.data as List;
      return data.map((e) => e['list_name'].toString()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> createCustomList(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    try {
      await ApiClient().localClient.post('/lists/$userId/create', data: {
        'list_name': name,
      });
    } catch (e) {
      // Ignore
    }
  }

  Future<void> addAnimeToList(AnimeModel anime, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    try {
      await ApiClient().localClient.post('/tracking/progress', data: {
        'userId': userId,
        'animeId': anime.id,
        'currentEpisode': 0,
        'totalEpisodes': anime.episodes ?? 0,
        'status': status,
        'title': anime.title,
        'imageUrl': anime.imageUrl,
      });
    } catch (e) {
      // Ignore
    }
  }

  Future<void> updateEpisodeProgress(String animeId, int watchedEps, {String? title, String? imageUrl, int? totalEpisodes}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    try {
      await ApiClient().localClient.post('/tracking/progress', data: {
        'userId': userId,
        'animeId': int.parse(animeId),
        'currentEpisode': watchedEps,
        'totalEpisodes': totalEpisodes ?? 0, 
        'title': title,
        'imageUrl': imageUrl,
        'status': 'Watching', 
      });
    } catch (e) {
      // Ignore
    }
  }

  Future<List<Map<String, dynamic>>> getSavedList(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return [];

    try {
      final response = await ApiClient().localClient.get('/tracking/$userId/$status');
      final data = response.data as List;
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> removeAnimeFromList(String status, int animeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    try {
      await ApiClient().localClient.delete('/tracking/$userId/$status/$animeId');
    } catch (e) {
      // Ignore
    }
  }

  Future<void> deleteCustomList(String listName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    try {
      await ApiClient().localClient.delete('/lists/$userId/$listName');
    } catch (e) {
      // Ignore
    }
  }
}
