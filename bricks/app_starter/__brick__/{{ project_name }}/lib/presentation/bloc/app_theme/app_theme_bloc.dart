import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/theme/load_theme.dart';
import '../../../domain/usecases/theme/save_theme.dart';

part 'app_theme_bloc.freezed.dart';
part 'app_theme_event.dart';
part 'app_theme_state.dart';

@injectable
class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  final LoadTheme loadTheme;
  final SaveTheme saveTheme;
  AppThemeBloc({required this.loadTheme, required this.saveTheme}) : super(AppThemeState.initial()) {
    on<_Started>(_onStarted);
    on<_Toggled>(_onToggled);
  }

  Future<void> _onStarted(_Started event, Emitter<AppThemeState> emit) async {
    final result = await loadTheme();
    result.fold(
      (failure) => emit(state.copyWith(message: 'Failed to load theme')),
      (themeMode) => emit(state.copyWith(themeMode: themeMode)),
    );
  }

  Future<void> _onToggled(_Toggled event, Emitter<AppThemeState> emit) async {
    final next = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: next));
    final saveResult = await saveTheme(next);
    saveResult.fold((failure) => emit(state.copyWith(message: 'Failed to save theme')), (_) {});
  }
}
