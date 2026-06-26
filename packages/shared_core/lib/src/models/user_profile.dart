class UserProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final String joinedDate;
  final String bio;
  final int animeCount;
  final int episodesCount;
  final double daysCount;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.joinedDate,
    required this.bio,
    this.animeCount = 0,
    this.episodesCount = 0,
    this.daysCount = 0.0,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? joinedDate,
    String? bio,
    int? animeCount,
    int? episodesCount,
    double? daysCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedDate: joinedDate ?? this.joinedDate,
      bio: bio ?? this.bio,
      animeCount: animeCount ?? this.animeCount,
      episodesCount: episodesCount ?? this.episodesCount,
      daysCount: daysCount ?? this.daysCount,
    );
  }
}
