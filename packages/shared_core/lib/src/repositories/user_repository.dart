class UserRepository {
  static const selectedAnimeKey = 'selected_anime';

  // Placeholder for user-related data fetching and manipulation
  Future<String> getUserName() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return "John Doe";
  }

  Future<String>getCurrentAnime() async {
    // Simulate fetching the currently selected anime from local storage
    await Future.delayed(Duration(milliseconds: 500));
    return selectedAnimeKey;
  }
}