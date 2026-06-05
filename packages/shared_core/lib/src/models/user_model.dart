class UserModel {
  final String id;
  final String username;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
