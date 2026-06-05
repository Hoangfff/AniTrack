import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const String _userKey = 'mock_current_user';

  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    
    final user = UserModel(
      id: 'mock_user_1',
      username: username,
      avatarUrl: 'https://ui-avatars.com/api/?name=$username',
    );
    
    final userJson = jsonEncode({
      'id': user.id,
      'username': user.username,
      'avatarUrl': user.avatarUrl,
    });
    
    await prefs.setString(_userKey, userJson);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }
}
