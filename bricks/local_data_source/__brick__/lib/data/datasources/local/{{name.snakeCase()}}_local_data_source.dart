import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class {{name.pascalCase()}}LocalDataSource {
  // TODO: make abstract method datasource
}

@LazySingleton(as: {{name.pascalCase()}}LocalDataSource)
class {{name.pascalCase()}}LocalDataSourceImpl implements {{name.pascalCase()}}LocalDataSource {  
  // TODO: implement abstract method datasource
}
