import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../repositories/app_theme_repository.dart';

@lazySingleton
class LoadTheme {
  final AppThemeRepository appThemeRepository;

  LoadTheme(this.appThemeRepository);

  Future<Either<Failure, ThemeMode>> call() async {
    return await appThemeRepository.loadTheme();
  }
}
