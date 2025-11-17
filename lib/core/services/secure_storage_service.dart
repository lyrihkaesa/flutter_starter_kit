import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Secure storage service for sensitive data (tokens, keys, credentials)
/// Uses platform-specific secure storage:
/// - Android: KeyStore
/// - iOS: Keychain
@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyPrivateKey = 'private_key';
  static const String _keyWalletAddress = 'wallet_address';

  // ========== Auth Tokens ==========

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  // ========== User Data ==========

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  // ========== Biometric Settings ==========

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  // ========== Crypto Wallet ==========

  Future<void> savePrivateKey(String privateKey) async {
    await _storage.write(key: _keyPrivateKey, value: privateKey);
  }

  Future<String?> getPrivateKey() async {
    return await _storage.read(key: _keyPrivateKey);
  }

  Future<void> saveWalletAddress(String address) async {
    await _storage.write(key: _keyWalletAddress, value: address);
  }

  Future<String?> getWalletAddress() async {
    return await _storage.read(key: _keyWalletAddress);
  }

  Future<void> deleteWalletData() async {
    await _storage.delete(key: _keyPrivateKey);
    await _storage.delete(key: _keyWalletAddress);
  }

  // ========== Generic Methods ==========

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
