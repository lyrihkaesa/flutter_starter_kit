import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/secure_storage_service.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> deleteTokens();
  Future<bool> isLoggedIn();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  final SecureStorageService _secureStorage;

  static const String _keyUser = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  AuthLocalDataSourceImpl(this._prefs, this._secureStorage);

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_keyUser, userJson);
    await _prefs.setBool(_keyIsLoggedIn, true);

    // Also save in secure storage for quick access
    await _secureStorage.saveUserId(user.id);
    await _secureStorage.saveUserEmail(user.email);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = _prefs.getString(_keyUser);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await _prefs.remove(_keyUser);
    await _prefs.setBool(_keyIsLoggedIn, false);
    await _secureStorage.saveUserId('');
    await _secureStorage.saveUserEmail('');
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    await _prefs.setBool(_keyIsLoggedIn, true);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  @override
  Future<void> deleteTokens() async {
    await _secureStorage.deleteTokens();
    await _prefs.setBool(_keyIsLoggedIn, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLoggedIn = _prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return false;

    // Verify token exists
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
