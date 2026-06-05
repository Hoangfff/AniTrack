class EpisodeModel {
  final String id;
  final int number;
  final String title;

  EpisodeModel({
    required this.id,
    required this.number,
    required this.title,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] ?? '',
      number: json['number'] ?? 0,
      title: json['title'] ?? 'Unknown',
    );
  }
}
