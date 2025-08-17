import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    @JsonKey(name: 'id') required int id,

    @JsonKey(name: 'name') String? name,

    @JsonKey(name: 'token') required String token,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromEntity(User entity) {
    return UserModel(id: entity.id, name: entity.name, token: entity.token);
  }

  User toEntity() {
    return User(id: id, name: name, token: token);
  }
}
