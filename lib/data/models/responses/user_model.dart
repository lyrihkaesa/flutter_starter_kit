import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/responses/user.dart';


part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    String? locale,
    String? timezone,
    String? theme,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      emailVerifiedAt: emailVerifiedAt,
      locale: locale,
      timezone: timezone,
      theme: theme,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      emailVerifiedAt: entity.emailVerifiedAt,
      locale: entity.locale,
      timezone: entity.timezone,
      theme: entity.theme,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
