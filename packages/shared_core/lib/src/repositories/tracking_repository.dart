import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anime_model.dart';

class TrackingRepository {
  static const String _listKey = 'mock_tracking_list';

  Future<void> addAnimeToList(AnimeModel anime, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final listString = prefs.getString(_listKey);
    Map<String, dynamic> trackingList = listString != null
        ? jsonDecode(listString)
        : {};

    trackingList[anime.id.toString()] = {
      'animeId': anime.id,
      'title': anime.title,
      'status': status,
      'progress': 0,
    };

    await prefs.setString(_listKey, jsonEncode(trackingList));
  }

  Future<void> updateEpisodeProgress(String animeId, int watchedEps) async {
    final prefs = await SharedPreferences.getInstance();
    final listString = prefs.getString(_listKey);
    if (listString == null) return;

    Map<String, dynamic> trackingList = jsonDecode(listString);
    if (trackingList.containsKey(animeId)) {
      trackingList[animeId]['progress'] = watchedEps;
      await prefs.setString(_listKey, jsonEncode(trackingList));
    }
  }

  Future<List<Map<String, dynamic>>> getSavedList(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final listString = prefs.getString(_listKey);
    if (listString == null) return [];

    Map<String, dynamic> trackingList = jsonDecode(listString);
    return trackingList.values
        .where((element) => element['status'] == status)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }
}
