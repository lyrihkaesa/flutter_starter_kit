import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/exception.dart';
import '../errors/failure.dart';

/// Memetakan [DioException] dari panggilan HTTP ke [Failure] domain.
Failure mapDioExceptionToFailure(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionError) {
    return const Failure.connection(message: 'Tidak dapat terhubung ke server');
  }

  final response = e.response;
  if (response != null) {
    final statusCode = response.statusCode;
    final responseData = response.data;

    if (statusCode == 422 && responseData is Map<String, dynamic>) {
      final rawErrors = responseData['errors'];
      final Map<String, List<String>> parsedErrors = {};

      if (rawErrors is Map<String, dynamic>) {
        rawErrors.forEach((key, value) {
          if (value is List) {
            parsedErrors[key] = value.map((item) => item.toString()).toList();
          }
        });
      }

      final message = responseData['message']?.toString() ?? 'Validasi gagal';
      return Failure.validation(parsedErrors, message: message);
    }

    if (statusCode == 401) {
      final message = (responseData is Map && responseData['message'] != null)
          ? responseData['message'].toString()
          : 'Kredensial tidak valid atau belum terautentikasi';
      return Failure.unauthorized(message: message);
    }

    final message = (responseData is Map && responseData['message'] != null)
        ? responseData['message'].toString()
        : 'Terjadi kesalahan pada server ($statusCode)';
    return Failure.server(message: message);
  }

  return Failure.server(message: e.message ?? 'Terjadi kesalahan jaringan');
}

/// Memetakan [AppException] lokal/remote ke [Failure] domain.
Failure mapAppExceptionToFailure(AppException e) {
  if (e is ValidationException) {
    return Failure.validation(e.errors, message: e.message);
  } else if (e is UnauthorizedException) {
    return Failure.unauthorized(
      message: e.message,
      error: e.error,
      errorDescription: e.errorDescription,
    );
  } else if (e is TokenExpiredException) {
    return Failure.tokenExpired(
      message: e.message,
      error: e.error,
      errorDescription: e.errorDescription,
    );
  } else if (e is ConnectionException) {
    return Failure.connection(message: e.message);
  } else if (e is DatabaseException) {
    return Failure.database(message: e.message);
  } else if (e is CacheException) {
    return Failure.cache(message: e.message);
  } else if (e is ServerException) {
    return Failure.server(
      message: e.message,
      error: e.error,
      errorDescription: e.errorDescription,
    );
  } else {
    return Failure.unknown(message: e.message ?? e.toString());
  }
}

/// Helper pembungkus pemanggilan DataSource di dalam Repository.
///
/// Mengisolasi penanganan [DioException], [AppException], dan generic error
/// sehingga Repository dapat memutuskan [Either<Failure, T>] secara konsisten.
Future<Either<Failure, T>> safeRepositoryCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e) {
    return Left(mapDioExceptionToFailure(e));
  } on AppException catch (e) {
    return Left(mapAppExceptionToFailure(e));
  } catch (e) {
    return Left(Failure.unknown(message: e.toString()));
  }
}
