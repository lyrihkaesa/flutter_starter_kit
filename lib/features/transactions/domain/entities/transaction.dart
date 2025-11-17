import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class Transaction extends Equatable {
  final String id;
  final String userId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final String? description;
  final String? txHash;
  final String? fromAddress;
  final String? toAddress;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    this.description,
    this.txHash,
    this.fromAddress,
    this.toAddress,
    this.metadata,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        amount,
        currency,
        description,
        txHash,
        fromAddress,
        toAddress,
        metadata,
        createdAt,
        completedAt,
      ];
}
