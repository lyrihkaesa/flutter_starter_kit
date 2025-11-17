import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class EnergyRental extends Equatable {
  final String id;
  final String? userId;
  final String recipientAddress;
  final int energyAmount;
  final int durationHours;
  final double priceInTrx;
  final TransactionStatus status;
  final String? txHash;
  final String? paymentAddress;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? completedAt;

  const EnergyRental({
    required this.id,
    this.userId,
    required this.recipientAddress,
    required this.energyAmount,
    required this.durationHours,
    required this.priceInTrx,
    required this.status,
    this.txHash,
    this.paymentAddress,
    required this.createdAt,
    required this.expiresAt,
    this.completedAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive => status == TransactionStatus.completed && !isExpired;

  @override
  List<Object?> get props => [
        id,
        userId,
        recipientAddress,
        energyAmount,
        durationHours,
        priceInTrx,
        status,
        txHash,
        paymentAddress,
        createdAt,
        expiresAt,
        completedAt,
      ];
}
