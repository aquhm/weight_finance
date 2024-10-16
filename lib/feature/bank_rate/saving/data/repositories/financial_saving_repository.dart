import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/data_sources/remote/abstract_financial_deposit_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/repositories/financial_repository.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/data_sources/remote/abstract_financial_saving_rate_api.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/managers/financial_data_manager.dart';

class FinancialSavingRepositoryImpl implements IFinancialRepository {
  final IFinancialSavingRateApi financialSavingRateApi;
  final FinancialDataManager _financialDataManager = GlobalAPI.managers.financialDataManager;

  FinancialSavingRepositoryImpl({required this.financialSavingRateApi});

  @override
  Future<Either<Failure, List<FinancialProduct>>> getFinancialProducts() async {
    try {
      var cachedData = _financialDataManager.savingProducts;
      if (cachedData.isEmpty) {
        final result = await financialSavingRateApi.getSavings();
        return result.fold(
          (failure) => Left(failure),
          (modelList) {
            final entityList = modelList.values.map((model) => model.toEntity()).toList();

            _financialDataManager.savingProducts = entityList;
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
