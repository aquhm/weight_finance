part of 'exchange_rate_bloc.dart';

@immutable
sealed class ExchangeRateState {}

final class ExchangeRateInitial extends ExchangeRateState {}

final class ExchangeRateLoading extends ExchangeRateState {}

final class ExchangeRateLoaded extends ExchangeRateState {
  final List<ExchangeRateEntity> exchangeRates;

  ExchangeRateLoaded(this.exchangeRates);
}

class ExchangeRateError extends ExchangeRateState {
  final String message;

  ExchangeRateError(this.message);
}
