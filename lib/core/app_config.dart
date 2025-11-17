import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class MyAppConfig {
  static final MyAppConfig _instance = MyAppConfig._internal();
  factory MyAppConfig() => _instance;
  MyAppConfig._internal();

  late final String _apiUrl;
  late final String _wsUrl;
  late final String _appName;
  late final String _adminPanelUrl;
  late final String _environment;
  late final int _apiTimeout;
  late final bool _enableApiLogging;
  String? _sentryDsn;

  static final Logger _logger = Logger(
    printer: PrettyPrinter(colors: true, printEmojis: true, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
  );

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');

      // Initialize required variables
      _instance._appName = _get('APP_NAME');
      _instance._apiUrl = _get('API_URL');
      _instance._wsUrl = _get('WS_URL');
      _instance._adminPanelUrl = _get('ADMIN_PANEL_URL');
      _instance._environment = _getOptional('ENVIRONMENT') ?? 'development';
      _instance._apiTimeout = int.tryParse(_getOptional('API_TIMEOUT') ?? '30000') ?? 30000;
      _instance._enableApiLogging = _getOptional('ENABLE_API_LOGGING')?.toLowerCase() == 'true';
      _instance._sentryDsn = _getOptional('SENTRY_DSN');

      _logger.i('✅ AppConfig loaded successfully');
      _logger.i('Environment: ${_instance._environment}');
      _logger.i('API URL: ${_instance._apiUrl}');
      _logger.i('WebSocket URL: ${_instance._wsUrl}');
    } catch (e) {
      _logger.e('‼️ AppConfig Error', error: e);
      _logger.w('➤ Pastikan file .env ada di root project');
      _logger.w('➤ Dan berisi variable yang diperlukan');
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

  static String? _getOptional(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) return null;
    return value;
  }

  // Static getters for easy access
  static String get appName => _instance._appName;
  static String get apiUrl => _instance._apiUrl;
  static String get wsUrl => _instance._wsUrl;
  static String get adminPanelUrl => _instance._adminPanelUrl;
  static String get environment => _instance._environment;
  static int get apiTimeout => _instance._apiTimeout;
  static bool get enableApiLogging => _instance._enableApiLogging;
  static String? get sentryDsn => _instance._sentryDsn;

  // Helper getters
  static bool get isDevelopment => _instance._environment == 'development';
  static bool get isProduction => _instance._environment == 'production';
  static bool get isStaging => _instance._environment == 'staging';
}
