import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../domain/repositories/app_theme_repository.dart';
import '../datasources/local/app_theme_local_data_source.dart';

@LazySingleton(as: AppThemeRepository)
class AppThemeRepositoryImpl implements AppThemeRepository {
  final AppThemeLocalDataSource appThemeLocalDataSource;

  AppThemeRepositoryImpl({required this.appThemeLocalDataSource});

  @override
  Future<Either<Failure, ThemeMode>> loadTheme() async {
    try {
      // Example: call remote datasource
      final result = await appThemeLocalDataSource.loadThemeMode();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ThemeMode>> saveTheme(ThemeMode mode) async {
    try {
      final result = await appThemeLocalDataSource.saveThemeMode(mode);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
