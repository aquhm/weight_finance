import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/exchange/data/data_sources/remote/abstract_exchange_rate_api.dart';
import 'package:weight_finance/feature/exchange/domain/entities/exchange_rate_entity.dart';
import 'package:weight_finance/feature/exchange/domain/repositories/abstract_exchange_rate_repository.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/managers/financial_data_manager.dart';

class ExchangeRateRepositoryImpl extends IExchangeRateRepository {
  final IExchangeRateApi exchangeRateApi;
  final FinancialDataManager _financialDataManager = GlobalAPI.managers.financialDataManager;

  ExchangeRateRepositoryImpl({
    required this.exchangeRateApi,
  });

  @override
  Future<Either<Failure, List<ExchangeRateEntity>>> getExchangeRateList() async {
    try {
      var cachedData = _financialDataManager.exchangeRates;
      if (cachedData.isEmpty) {
        final result = await exchangeRateApi.getExchangeRateList();
        return result.fold(
          (failure) => Left(failure),
          (modelList) {
            final entityList = modelList.map((model) => model.toEntity()).toList();

            _financialDataManager.exchangeRates = entityList;

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
