part of 'app_theme_bloc.dart';

@freezed
sealed class AppThemeState with _$AppThemeState {
  const factory AppThemeState({
    String? message,
    required ThemeMode themeMode,
  }) = _AppThemeState;

  factory AppThemeState.initial() => const AppThemeState(
        message: null,
        themeMode: ThemeMode.system,
  );
}
