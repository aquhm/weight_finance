import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';

abstract interface class IFinancialRepository {
  Future<Either<Failure, List<FinancialProduct>>> getFinancialProducts();
}
