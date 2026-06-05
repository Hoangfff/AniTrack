class StreamingLinkModel {
  final String url;
  final String quality;

  StreamingLinkModel({
    required this.url,
    required this.quality,
  });

  factory StreamingLinkModel.fromJson(Map<String, dynamic> json) {
    return StreamingLinkModel(
      url: json['url'] ?? '',
      quality: json['quality'] ?? 'default',
    );
  }
}
