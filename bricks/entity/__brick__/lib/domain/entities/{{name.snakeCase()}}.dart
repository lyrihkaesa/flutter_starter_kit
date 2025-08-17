import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}.freezed.dart';

@freezed
sealed class {{name.pascalCase()}} with _${{name.pascalCase()}} {
  const factory {{name.pascalCase()}}({
    {{#fields}}
    {{requiredKeyword}}{{fieldType}} {{fieldName}},
    {{/fields}}
  }) = _{{name.pascalCase()}};

  const {{name.pascalCase()}}._();
}
