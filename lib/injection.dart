import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_config.dart';
import 'core/network/dio_interceptor.dart';
import 'core/services/secure_storage_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt', preferRelativeImports: true, asExtension: false)
void configureDependencies() => $initGetIt(getIt);

@module
abstract class ExternalsModule {
  // Logger
  @lazySingleton
  Logger get logger => Logger(
        printer: PrettyPrinter(
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

  // Secure Storage
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  // Local Authentication (Biometric)
  @lazySingleton
  LocalAuthentication get localAuth => LocalAuthentication();

  // SharedPreferences
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  // Dio HTTP Client
  @lazySingleton
  Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: MyAppConfig.apiUrl,
      connectTimeout: Duration(milliseconds: MyAppConfig.apiTimeout),
      receiveTimeout: Duration(milliseconds: MyAppConfig.apiTimeout),
      sendTimeout: Duration(milliseconds: MyAppConfig.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    final logger = getIt<Logger>();
    final secureStorage = getIt<SecureStorageService>();

    // Auth interceptor (add token to requests)
    dio.interceptors.add(AuthInterceptor(secureStorage, logger));

    // Token refresh interceptor (handle 401 errors)
    dio.interceptors.add(TokenRefreshInterceptor(dio, secureStorage, logger));

    // Retry interceptor (retry failed requests)
    dio.interceptors.add(RetryInterceptor(
      dio,
      logger,
      maxRetries: 3,
      retryDelay: const Duration(seconds: 2),
    ));

    // Connectivity interceptor (check internet)
    dio.interceptors.add(ConnectivityInterceptor(logger));

    // Pretty logger (only in development)
    if (MyAppConfig.enableApiLogging && MyAppConfig.isDevelopment) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    return dio;
  }
}
