import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../repositories/app_theme_repository.dart';

@lazySingleton
class SaveTheme {
  final AppThemeRepository appThemeRepository;

  SaveTheme(this.appThemeRepository);

  Future<Either<Failure, ThemeMode>> call(ThemeMode mode) async {
    return await appThemeRepository.saveTheme(mode);
  }
}
