import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppThemeLocalDataSource {
  Future<ThemeMode> saveThemeMode(ThemeMode mode);
  Future<ThemeMode> loadThemeMode();
}

@LazySingleton(as: AppThemeLocalDataSource)
class AppThemeLocalDataSourceImpl implements AppThemeLocalDataSource {
  static const _keyThemeMode = 'app_theme_mode';

  const AppThemeLocalDataSourceImpl();

  @override
  Future<ThemeMode> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, _themeModeToString(mode));
    return mode;
  }

  @override
  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyThemeMode);
    if (value == null) return ThemeMode.system;
    return _stringToThemeMode(value);
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
