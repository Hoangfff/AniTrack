class MegaPlayHelper {
  /// Sinh ra đường link Iframe (embedUrl) để nhúng vào HtmlElementView
  /// Dựa trên API của megaplay.buzz: https://megaplay.buzz/stream/mal/{mal-id}/{ep-num}/{language}
  static String generateEmbedUrl({
    required int malId,
    required int episodeNumber,
    String lang = 'sub',
  }) {
    return 'https://megaplay.buzz/stream/mal/$malId/$episodeNumber/$lang';
  }
}
