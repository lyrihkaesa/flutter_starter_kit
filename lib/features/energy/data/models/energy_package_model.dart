import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/energy_package.dart';

part 'energy_package_model.g.dart';

@JsonSerializable()
class EnergyPackageModel extends EnergyPackage {
  const EnergyPackageModel({
    required super.id,
    required super.energyAmount,
    required super.durationHours,
    required super.priceInTrx,
    required super.estimatedTransactions,
    required super.savingsPercentage,
    required super.savingsAmount,
    super.isPopular,
    super.isAvailable,
  });

  factory EnergyPackageModel.fromJson(Map<String, dynamic> json) =>
      _$EnergyPackageModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnergyPackageModelToJson(this);

  factory EnergyPackageModel.fromEntity(EnergyPackage package) {
    return EnergyPackageModel(
      id: package.id,
      energyAmount: package.energyAmount,
      durationHours: package.durationHours,
      priceInTrx: package.priceInTrx,
      estimatedTransactions: package.estimatedTransactions,
      savingsPercentage: package.savingsPercentage,
      savingsAmount: package.savingsAmount,
      isPopular: package.isPopular,
      isAvailable: package.isAvailable,
    );
  }

  EnergyPackage toEntity() {
    return EnergyPackage(
      id: id,
      energyAmount: energyAmount,
      durationHours: durationHours,
      priceInTrx: priceInTrx,
      estimatedTransactions: estimatedTransactions,
      savingsPercentage: savingsPercentage,
      savingsAmount: savingsAmount,
      isPopular: isPopular,
      isAvailable: isAvailable,
    );
  }
}
