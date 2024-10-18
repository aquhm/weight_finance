import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
import 'package:weight_finance/feature/metal_price/domain/use_cases/get_commodity_prices.dart';

part 'commodity_price_event.dart';
part 'commodity_price_state.dart';

class CommodityPricesBloc extends Bloc<CommodityPriceEvent, CommodityPriceState> {
  late String currency;
  late String unit;
  final GetCommodityPricesUseCase getCommodityPricesUseCase;

  CommodityPricesBloc({required this.getCommodityPricesUseCase}) : super(CommodityPricesInitial()) {
    on<LoadCommodityPrices>(_onLoadCommodityPrices);
    on<ChangeCurrency>(_onChangeCurrency);
    on<ChangeUnit>(_onChangeUnit);
  }

  void _onLoadCommodityPrices(LoadCommodityPrices event, Emitter<CommodityPriceState> emit) async {
    emit(CommodityPricesLoading());
    final result = await getCommodityPricesUseCase(NoParams());
    result.fold(
      (failure) => emit(CommodityPricesError(message: failure.toString())),
      (data) => emit(CommodityPricesLoaded(data: data, currency: 'USD', unit: 'oz')),
    );
  }

  void _onChangeCurrency(ChangeCurrency event, Emitter<CommodityPriceState> emit) {
    if (state is CommodityPricesLoaded) {
      final currentState = state as CommodityPricesLoaded;
      emit(currentState.copyWith(currency: event.currency));
    }
  }

  void _onChangeUnit(ChangeUnit event, Emitter<CommodityPriceState> emit) {
    unit = event.unit;
    if (state is CommodityPricesLoaded) {
      final currentState = state as CommodityPricesLoaded;
      emit(currentState.copyWith(unit: event.unit));
    }
  }
}
