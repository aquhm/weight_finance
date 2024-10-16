part of 'exchange_rate_bloc.dart';

@immutable
sealed class ExchangeRateEvent {}

final class FetchExchangeRateEvent extends ExchangeRateEvent {}
