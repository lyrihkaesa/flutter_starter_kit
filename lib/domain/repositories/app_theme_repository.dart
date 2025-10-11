import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';

abstract class AppThemeRepository {
  Future<Either<Failure, ThemeMode>> loadTheme();
  Future<Either<Failure, ThemeMode>> saveTheme(ThemeMode mode);
}
