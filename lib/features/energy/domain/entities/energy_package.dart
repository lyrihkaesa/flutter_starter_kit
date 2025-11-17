import 'package:equatable/equatable.dart';

class EnergyPackage extends Equatable {
  final String id;
  final int energyAmount;
  final int durationHours;
  final double priceInTrx;
  final int estimatedTransactions;
  final double savingsPercentage;
  final double savingsAmount;
  final bool isPopular;
  final bool isAvailable;

  const EnergyPackage({
    required this.id,
    required this.energyAmount,
    required this.durationHours,
    required this.priceInTrx,
    required this.estimatedTransactions,
    required this.savingsPercentage,
    required this.savingsAmount,
    this.isPopular = false,
    this.isAvailable = true,
  });

  String get durationLabel {
    if (durationHours < 24) {
      return '$durationHours Hour${durationHours > 1 ? 's' : ''}';
    } else {
      final days = durationHours ~/ 24;
      return '$days Day${days > 1 ? 's' : ''}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        energyAmount,
        durationHours,
        priceInTrx,
        estimatedTransactions,
        savingsPercentage,
        savingsAmount,
        isPopular,
        isAvailable,
      ];
}
