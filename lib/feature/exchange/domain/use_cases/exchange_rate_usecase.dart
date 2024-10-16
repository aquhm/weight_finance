import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/exchange/domain/repositories/abstract_exchange_rate_repository.dart';

class ExchangeRateUseCase implements UseCase {
  final IExchangeRateRepository repository;
  const ExchangeRateUseCase({required this.repository});

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getExchangeRateList();
  }
}
