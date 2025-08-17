import 'package:freezed_annotation/freezed_annotation.dart';
{{#useEntity}}
import '../../domain/entities/{{name.snakeCase()}}.dart';
{{/useEntity}}

part '{{name.snakeCase()}}_model.freezed.dart';
part '{{name.snakeCase()}}_model.g.dart';

@freezed
sealed class {{name.pascalCase()}}Model with _${{name.pascalCase()}}Model {
  @JsonSerializable(explicitToJson: true)
  const factory {{name.pascalCase()}}Model({
    {{#fields}}
    @JsonKey(name: '{{fieldName.snakeCase()}}') {{requiredKeyword}}{{fieldType}} {{fieldName.camelCase()}},
    {{/fields}}
  }) = _{{name.pascalCase()}}Model;

  const {{name.pascalCase()}}Model._();

  factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}ModelFromJson(json);

  {{#useEntity}}
  factory {{name.pascalCase()}}Model.fromEntity({{name.pascalCase()}} entity) {
    return {{name.pascalCase()}}Model(
      {{#fields}}
      {{fieldName.camelCase()}}: entity.{{fieldName.camelCase()}},
      {{/fields}}
    );
  }

  {{name.pascalCase()}} toEntity() {
    return {{name.pascalCase()}}(
      {{#fields}}
      {{fieldName.camelCase()}}: {{fieldName.camelCase()}},
      {{/fields}}
    );
  }
  {{/useEntity}}
}
