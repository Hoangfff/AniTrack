import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../network/api_client.dart';
import 'auth_provider.dart';

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final int? userId;
  
  UserProfileNotifier(this.userId) : super(const AsyncValue.loading()) {
    if (userId == null) {
      state = const AsyncValue.data(null);
    } else {
      _fetchProfile();
    }
  }

  Future<void> _fetchProfile() async {
    if (userId == null) return;
    try {
      final response = await ApiClient().localClient.get('/profile/$userId');
      final data = response.data;
      
      int animeCount = 0;
      int episodesCount = 0;
      double daysCount = 0.0;
      try {
        final statsResponse = await ApiClient().localClient.get('/profile/$userId/stats');
        animeCount = statsResponse.data['animeCount'] ?? 0;
        episodesCount = statsResponse.data['episodesCount'] ?? 0;
        daysCount = (statsResponse.data['daysCount'] ?? 0.0).toDouble();
      } catch (e) {
        // Ignore stats fetch error
      }

      state = AsyncValue.data(UserProfile(
        id: data['id'].toString(),
        name: data['name'],
        avatarUrl: data['avatarUrl'],
        joinedDate: data['joinedDate'],
        bio: data['bio'],
        animeCount: animeCount,
        episodesCount: episodesCount,
        daysCount: daysCount,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({String? name, String? avatarUrl, String? bio}) async {
    if (state.value == null || userId == null) return;
    
    // Optimistic update
    final oldProfile = state.value!;
    state = AsyncValue.data(oldProfile.copyWith(
      name: name,
      avatarUrl: avatarUrl,
      bio: bio,
    ));

    try {
      await ApiClient().localClient.put('/profile/$userId', data: {
        'name': name,
        'bio': bio,
        'avatarUrl': avatarUrl,
      });
    } catch (e) {
      // Revert on failure
      state = AsyncValue.data(oldProfile);
    }
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final authState = ref.watch(authProvider);
  return UserProfileNotifier(authState.value);
});
