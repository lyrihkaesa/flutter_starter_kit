/// Wallet domain entity for cryptocurrency
class Wallet {
  final String id;
  final String address;
  final String name;
  final String? blockchain; // e.g., "TRON", "ETH", "BTC"
  final double balance;
  final String? currency; // e.g., "TRX", "ETH", "BTC"
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Wallet({
    required this.id,
    required this.address,
    required this.name,
    this.blockchain,
    this.balance = 0.0,
    this.currency,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  Wallet copyWith({
    String? id,
    String? address,
    String? name,
    String? blockchain,
    double? balance,
    String? currency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      address: address ?? this.address,
      name: name ?? this.name,
      blockchain: blockchain ?? this.blockchain,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
