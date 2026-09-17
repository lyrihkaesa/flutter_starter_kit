import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/errors/exception.dart';
import 'package:flutter_starter_kit/core/errors/failure.dart';
import 'package:flutter_starter_kit/core/utils/error_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('safeRepositoryCall & ErrorHandler', () {
    test('mengembalikan Right(data) jika eksekusi berhasil', () async {
      final result = await safeRepositoryCall(() async => 'success_data');

      result.fold(
        (failure) => fail('Harusnya mengembalikan Right'),
        (data) => expect(data, 'success_data'),
      );
    });

    test('memetakan DioException connectionTimeout menjadi Failure.connection', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await safeRepositoryCall(() async {
        throw dioException;
      });

      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect((failure as ConnectionFailure).message, 'Tidak dapat terhubung ke server');
        },
        (_) => fail('Harusnya mengembalikan Left'),
      );
    });

    test('memetakan DioException 422 dengan validation errors menjadi Failure.validation', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'message': 'The given data was invalid.',
            'errors': {
              'email': ['Email sudah terdaftar'],
            },
          },
        ),
      );

      final result = await safeRepositoryCall(() async {
        throw dioException;
      });

      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          final validation = failure as ValidationFailure;
          expect(validation.message, 'The given data was invalid.');
          expect(validation.errors['email'], contains('Email sudah terdaftar'));
        },
        (_) => fail('Harusnya mengembalikan Left'),
      );
    });

    test('memetakan DioException 401 menjadi Failure.unauthorized', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'message': 'Unauthenticated.'},
        ),
      );

      final result = await safeRepositoryCall(() async {
        throw dioException;
      });

      result.fold(
        (failure) {
          expect(failure, isA<UnauthorizedFailure>());
          expect((failure as UnauthorizedFailure).message, 'Unauthenticated.');
        },
        (_) => fail('Harusnya mengembalikan Left'),
      );
    });

    test('memetakan DioException 500 menjadi Failure.server', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {'message': 'Internal Server Error'},
        ),
      );

      final result = await safeRepositoryCall(() async {
        throw dioException;
      });

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Internal Server Error');
        },
        (_) => fail('Harusnya mengembalikan Left'),
      );
    });

    test('memetakan AppException (CacheException) menjadi Failure.cache', () async {
      final result = await safeRepositoryCall(() async {
        throw const CacheException(message: 'Gagal membaca storage');
      });

      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect((failure as CacheFailure).message, 'Gagal membaca storage');
        },
        (_) => fail('Harusnya mengembalikan Left'),
      );
    });

    test('memetakan generic Exception menjadi Failure.unknown', () async {
      final result = await safeRepositoryCall(() async {
        throw Exception('Unexpected error');
      });

      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
        },
        (_) => fail('Harusnya mengembalikan Left'),
      );
    });
  });
}
