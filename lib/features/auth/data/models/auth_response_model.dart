import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required UserModel user,
    required super.accessToken,
    required super.refreshToken,
  }) : super(user: user);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  factory AuthResponseModel.fromEntity(AuthResponse authResponse) {
    return AuthResponseModel(
      user: UserModel.fromEntity(authResponse.user),
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );
  }

  AuthResponse toEntity() {
    return AuthResponse(
      user: (user as UserModel).toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
