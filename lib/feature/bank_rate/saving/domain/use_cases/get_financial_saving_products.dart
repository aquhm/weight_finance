import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/repositories/financial_repository.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';

class GetFinancialSavingProductsUseCase implements UseCase {
  final IFinancialRepository repository;

  const GetFinancialSavingProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<FinancialProduct>>> call(params) async {
    return await repository.getFinancialProducts();
  }
}
