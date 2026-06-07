class EpisodeModel {
  final String id;
  final int number;
  final String title;

  EpisodeModel({required this.id, required this.number, required this.title});

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] ?? '',
      number: json['number'] ?? 0,
      title: json['title'] ?? 'Unknown',
    );
  }
}

class JikanEpisodeModel {
  final String id;
  final String url;
  final String title;
  final String titleJapanese;
  final String titleRomanji;
  final DateTime aired;
  final double score;
  final bool filler;
  final bool recap;
  final String forumUrl;

  JikanEpisodeModel({
    required this.id,
    required this.url,
    required this.title,
    required this.titleJapanese,
    required this.titleRomanji,
    required this.aired,
    required this.score,
    required this.filler,
    required this.recap,
    required this.forumUrl,
  });

  factory JikanEpisodeModel.fromJson(Map<String, dynamic> json) {
    return JikanEpisodeModel(
      id: json['mal_id']?.toString() ?? '',
      url: json['url'] ?? '',
      title: json['title'] ?? 'Unknown',
      titleJapanese: json['title_japanese'] ?? 'Unknown',
      titleRomanji: json['title_romanji'] ?? 'Unknown',
      aired: json['aired'] != null
          ? DateTime.parse(json['aired'])
          : DateTime.now(),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      filler: json['filler'] ?? false,
      recap: json['recap'] ?? false,
      forumUrl: json['forum_url'] ?? '',
    );
  }
}
