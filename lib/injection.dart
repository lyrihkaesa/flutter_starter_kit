import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt', preferRelativeImports: true, asExtension: false)
void configureDependencies() => $initGetIt(getIt);

@module
abstract class ExternalsModule {
  @lazySingleton
  Dio get dio => Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? 'https://hris.sochainformatika.com/public'));
}
