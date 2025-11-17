import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/energy_package.dart';
import '../entities/energy_rental.dart';

abstract class EnergyRepository {
  Future<Either<Failure, List<EnergyPackage>>> getEnergyPackages({
    int? durationHours,
  });

  Future<Either<Failure, EnergyRental>> quickBuyEnergy({
    required String recipientAddress,
    required int energyAmount,
    required int durationHours,
  });

  Future<Either<Failure, EnergyRental>> rentEnergy({
    required String packageId,
    required String recipientAddress,
  });

  Future<Either<Failure, List<EnergyRental>>> getEnergyHistory({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, double>> getEnergyBalance({
    required String address,
  });

  Future<Either<Failure, Map<String, dynamic>>> calculateEnergy({
    required int dailyTransactions,
  });

  Future<Either<Failure, EnergyRental>> getEnergyRentalById({
    required String id,
  });

  Future<Either<Failure, void>> checkEnergyRentalStatus({
    required String id,
  });
}
