import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import '../repositories/financial_repository.dart';

class GetFinancialDepositProductsUseCase implements UseCase {
  final IFinancialRepository repository;

  const GetFinancialDepositProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<FinancialProduct>>> call(params) async {
    return await repository.getFinancialProducts();
  }
}
