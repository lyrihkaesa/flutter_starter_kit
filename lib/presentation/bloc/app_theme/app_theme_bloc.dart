import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_bloc.freezed.dart';
part 'app_theme_event.dart';
part 'app_theme_state.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(AppThemeState.initial()) {
    on<_Started>(_onStarted);
    on<_Toggled>(_onToggled);
    on<_SetTheme>(_onSetTheme);
  }

  Future<void> _onStarted(_Started event, Emitter<AppThemeState> emit) async {}

  Future<void> _onToggled(_Toggled event, Emitter<AppThemeState> emit) async {
    final next = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: next));
  }

  Future<void> _onSetTheme(_SetTheme event, Emitter<AppThemeState> emit) async {
    emit(state.copyWith(themeMode: event.mode));
  }
}


