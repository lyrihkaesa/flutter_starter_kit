import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyAppConfig {
  static final MyAppConfig _instance = MyAppConfig._internal();
  factory MyAppConfig() => _instance;
  MyAppConfig._internal();

  late final String _apiUrl;
  late final String _appName;

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');

      // Initialize variables
      _instance._appName = _get('APP_NAME');
      _instance._apiUrl = _get('API_URL');
    } catch (e) {
      print('‼️ AppConfig Error: $e');
      print('➜ Application terminated');
      print('➜ Make sure file .env exists in the root directory');
      exit(1);
    }
  }

  static String _get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Env variable $key not found or value is empty');
    }
    return value;
  }

  // Static getters untuk akses mudah
  static String get appName => _instance._appName;
  static String get apiUrl => _instance._apiUrl;
}
