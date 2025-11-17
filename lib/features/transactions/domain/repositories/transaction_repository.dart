import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_constants.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions({
    int page = 1,
    int limit = 20,
    TransactionType? type,
    TransactionStatus? status,
  });

  Future<Either<Failure, Transaction>> getTransactionById({
    required String id,
  });

  Future<Either<Failure, TransactionStatus>> getTransactionStatus({
    required String id,
  });
}
