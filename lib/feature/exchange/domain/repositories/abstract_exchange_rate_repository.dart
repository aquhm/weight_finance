import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/exchange/domain/entities/exchange_rate_entity.dart';

abstract class IExchangeRateRepository {
  Future<Either<Failure, List<ExchangeRateEntity>>> getExchangeRateList();
}
