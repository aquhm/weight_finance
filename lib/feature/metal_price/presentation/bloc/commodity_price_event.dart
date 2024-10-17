part of 'commodity_price_bloc.dart';

abstract class CommodityPriceEvent extends Equatable {
  const CommodityPriceEvent();

  @override
  List<Object> get props => [];
}

class LoadCommodityPrices extends CommodityPriceEvent {}

class ChangeCurrency extends CommodityPriceEvent {
  final String currency;

  const ChangeCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}

class ChangeUnit extends CommodityPriceEvent {
  final String unit;

  const ChangeUnit(this.unit);

  @override
  List<Object> get props => [unit];
}
