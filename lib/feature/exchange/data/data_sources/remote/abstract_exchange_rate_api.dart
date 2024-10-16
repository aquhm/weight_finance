import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/exchange/data/models/exchange_rate_model.dart';

abstract interface class IExchangeRateApi {
  Future<Either<Failure, List<ExchangeRateModel>>> getExchangeRateList();
}
