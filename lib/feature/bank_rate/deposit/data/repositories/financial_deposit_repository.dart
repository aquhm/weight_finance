import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/data_sources/remote/abstract_financial_deposit_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/repositories/financial_repository.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/managers/financial_data_manager.dart';

class FinancialDepositRepositoryImpl implements IFinancialRepository {
  final IFinancialDepositRateApi financialDepositRateApi;
  final FinancialDataManager _financialDataManager = GlobalAPI.managers.financialDataManager;

  FinancialDepositRepositoryImpl({required this.financialDepositRateApi});

  @override
  Future<Either<Failure, List<FinancialProduct>>> getFinancialProducts() async {
    try {
      var cachedData = _financialDataManager.depositProducts;
      if (cachedData.isEmpty) {
        final result = await financialDepositRateApi.getDeposits();
        return result.fold(
          (failure) => Left(failure),
          (modelList) {
            final entityList = modelList.values.map((model) => model.toEntity()).toList();

            _financialDataManager.depositProducts = entityList;
            return Right(entityList);
          },
        );
      } else {
        return Right(cachedData);
      }
    } catch (e) {
      return Left(Failure.unexpectedError(e.toString()));
    }
  }
}
