// // Entity classes
// import 'package:equatable/equatable.dart';
//
// class CommodityPricesEntity extends Equatable {
//   final Map<String, TimeframeEntity> timeframes;
//
//   const CommodityPricesEntity({required this.timeframes});
//
//   @override
//   List<Object?> get props => [timeframes];
// }
//
// class TimeframeEntity extends Equatable {
//   final String timeframe;
//   final Map<String, CommodityEntity> metals;
//
//   const TimeframeEntity({required this.timeframe, required this.metals});
//
//   @override
//   List<Object?> get props => [timeframe, metals];
// }
//
// class CommodityEntity extends Equatable {
//   final String metal;
//   final Map<String, double> prices;
//
//   const CommodityEntity({required this.metal, required this.prices});
//
//   double? getPriceForDate(String date) {
//     return prices[date];
//   }
//
//   @override
//   List<Object?> get props => [metal, prices];
// }

import 'package:equatable/equatable.dart';

class CommodityPricesEntity extends Equatable {
  final Map<String, MetalEntity> metals;

  const CommodityPricesEntity({required this.metals});

  @override
  List<Object?> get props => [metals];
}

class MetalEntity extends Equatable {
  final Map<String, List<PricePointEntity>> timeframes;

  const MetalEntity({required this.timeframes});

  @override
  List<Object?> get props => [timeframes];
}

class PricePointEntity extends Equatable {
  final String date;
  final double price;

  const PricePointEntity({required this.date, required this.price});

  @override
  List<Object?> get props => [date, price];
}
