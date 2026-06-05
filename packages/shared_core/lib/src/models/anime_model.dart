import 'genre_model.dart';

class AnimeModel {
  final int id;
  final String title;
  final String imageUrl;
  final String synopsis;
  final double score;
  final String status;
  final int episodes;
  final List<GenreModel> genres;

  AnimeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.score,
    required this.status,
    required this.episodes,
    required this.genres,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      synopsis: json['synopsis'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      episodes: json['episodes'] ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
