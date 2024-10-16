import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/exchange/domain/entities/exchange_rate_entity.dart';

import '../../domain/use_cases/exchange_rate_usecase.dart';

part 'exchange_rate_event.dart';
part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  final ExchangeRateUseCase exchangeRateUseCase;

  ExchangeRateBloc({required this.exchangeRateUseCase}) : super(ExchangeRateInitial()) {
    on<FetchExchangeRateEvent>(_onFetchExchangeRate);
  }

  Future<void> _onFetchExchangeRate(
    FetchExchangeRateEvent event,
    Emitter<ExchangeRateState> emit,
  ) async {
    emit(ExchangeRateLoading());

    final result = await exchangeRateUseCase(NoParams());

    result.fold(
      (failure) => emit(ExchangeRateError(failure.toString())),
      (exchangeRates) => emit(ExchangeRateLoaded(exchangeRates)),
    );
  }
}
