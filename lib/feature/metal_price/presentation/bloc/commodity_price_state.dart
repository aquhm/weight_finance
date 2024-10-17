part of 'commodity_price_bloc.dart';

abstract class CommodityPriceState extends Equatable {
  const CommodityPriceState();

  @override
  List<Object> get props => [];
}

class CommodityPricesInitial extends CommodityPriceState {}

class CommodityPricesLoading extends CommodityPriceState {}

class CommodityPricesLoaded extends CommodityPriceState {
  final CommodityPricesEntity data;
  final String currency;
  final String unit;

  const CommodityPricesLoaded({
    required this.data,
    required this.currency,
    required this.unit,
  });

  CommodityPricesLoaded copyWith({
    CommodityPricesEntity? data,
    String? currency,
    String? unit,
  }) {
    return CommodityPricesLoaded(
      data: data ?? this.data,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object> get props => [data, currency, unit];
}

class CommodityPricesError extends CommodityPriceState {
  final String message;

  const CommodityPricesError({required this.message});

  @override
  List<Object> get props => [message];
}
