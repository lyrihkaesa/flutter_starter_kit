import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? walletAddress;
  final String? profileImage;
  final bool emailVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.walletAddress,
    this.profileImage,
    required this.emailVerified,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        walletAddress,
        profileImage,
        emailVerified,
        isActive,
        createdAt,
        updatedAt,
      ];
}
