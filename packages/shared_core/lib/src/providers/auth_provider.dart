import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';

class AuthNotifier extends StateNotifier<AsyncValue<int?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      state = AsyncValue.data(userId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiClient().localClient.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      final userId = response.data['userId'] as int;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      
      state = AsyncValue.data(userId);
    } catch (e, st) {
      state = const AsyncValue.data(null);
      if (e is DioException) {
        final errorMsg = e.response?.data['error'] ?? 'Lỗi kết nối máy chủ';
        throw Exception(errorMsg);
      }
      rethrow;
    }
  }

  Future<void> register(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiClient().localClient.post('/auth/register', data: {
        'username': username,
        'password': password,
      });

      final userId = response.data['userId'] as int;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      
      state = AsyncValue.data(userId);
    } catch (e, st) {
      state = const AsyncValue.data(null);
      if (e is DioException) {
        final errorMsg = e.response?.data['error'] ?? 'Lỗi kết nối máy chủ';
        throw Exception(errorMsg);
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<int?>>((ref) {
  return AuthNotifier();
});
