import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required int id,
    String? name,
    required String token,
  }) = _User;

  const User._();
}
