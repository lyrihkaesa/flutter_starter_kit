import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  // TODO: create abstract method datasource
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  // TODO: implement abstract method datasource
}
