import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

abstract class {{name.pascalCase()}}RemoteDataSource {
  // TODO: create abstract method datasource
}

@LazySingleton(as: {{name.pascalCase()}}RemoteDataSource)
class {{name.pascalCase()}}RemoteDataSourceImpl implements {{name.pascalCase()}}RemoteDataSource {
  final Dio dio;

  {{name.pascalCase()}}RemoteDataSourceImpl({required this.dio});

  // TODO: implement abstract method datasource
}
