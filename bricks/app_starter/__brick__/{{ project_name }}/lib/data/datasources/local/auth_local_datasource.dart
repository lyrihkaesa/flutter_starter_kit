import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/exception.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

const _kAuthTokenKey = 'AUTH_TOKEN';

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _kAuthTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Gagal menyimpan token keamanan: ${e.toString()}');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _kAuthTokenKey);
    } catch (e) {
      throw CacheException(message: 'Gagal membaca token keamanan: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _kAuthTokenKey);
    } catch (e) {
      throw CacheException(message: 'Gagal menghapus token keamanan: ${e.toString()}');
    }
  }
}
