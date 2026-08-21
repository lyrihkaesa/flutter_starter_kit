import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    String? emailVerifiedAt,
    String? locale,
    String? timezone,
    String? theme,
    String? createdAt,
    String? updatedAt,
  }) = _User;
}
