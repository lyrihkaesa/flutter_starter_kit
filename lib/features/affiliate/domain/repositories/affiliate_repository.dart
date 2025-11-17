import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/affiliate_stats.dart';

abstract class AffiliateRepository {
  Future<Either<Failure, AffiliateStats>> getAffiliateStats();

  Future<Either<Failure, String>> generateReferralCode();

  Future<Either<Failure, void>> withdraw({
    required double amount,
    required String walletAddress,
  });
}
