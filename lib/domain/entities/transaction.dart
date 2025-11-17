/// Transaction domain entity for cryptocurrency transactions
class Transaction {
  final String id;
  final String hash;
  final String fromAddress;
  final String toAddress;
  final double amount;
  final String currency;
  final TransactionType type;
  final TransactionStatus status;
  final double? fee;
  final String? blockchain;
  final String? memo;
  final DateTime createdAt;
  final DateTime? confirmedAt;

  const Transaction({
    required this.id,
    required this.hash,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.currency,
    required this.type,
    required this.status,
    this.fee,
    this.blockchain,
    this.memo,
    required this.createdAt,
    this.confirmedAt,
  });

  Transaction copyWith({
    String? id,
    String? hash,
    String? fromAddress,
    String? toAddress,
    double? amount,
    String? currency,
    TransactionType? type,
    TransactionStatus? status,
    double? fee,
    String? blockchain,
    String? memo,
    DateTime? createdAt,
    DateTime? confirmedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      status: status ?? this.status,
      fee: fee ?? this.fee,
      blockchain: blockchain ?? this.blockchain,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }
}

enum TransactionType {
  send,
  receive,
  stake,
  unstake,
  reward,
}

enum TransactionStatus {
  pending,
  confirmed,
  failed,
  cancelled,
}
