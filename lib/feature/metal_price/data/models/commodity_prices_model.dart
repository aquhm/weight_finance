// import 'dart:convert';
// import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
//
// class CommodityPricesDto {
//   final Map<String, TimeframeDto> timeframes;
//
//   CommodityPricesDto({required this.timeframes});
//
//   factory CommodityPricesDto.fromJson(Map<String, dynamic> json) {
//     Map<String, TimeframeDto> timeframes = {};
//     json.forEach((key, value) {
//       timeframes[key] = TimeframeDto.fromJson(key, value as Map<String, dynamic>);
//     });
//     return CommodityPricesDto(timeframes: timeframes);
//   }
//
//   factory CommodityPricesDto.fromRawJson(String str) => CommodityPricesDto.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   Map<String, dynamic> toJson() {
//     return timeframes.map((key, value) => MapEntry(key, value.toJson()));
//   }
//
//   CommodityPricesEntity toEntity() {
//     return CommodityPricesEntity(
//       timeframes: timeframes.map((key, value) => MapEntry(key, value.toEntity())),
//     );
//   }
// }
//
// class TimeframeDto {
//   final String timeframe;
//   final Map<String, CommodityDto> metals;
//
//   TimeframeDto({required this.timeframe, required this.metals});
//
//   factory TimeframeDto.fromJson(String timeframe, Map<String, dynamic> json) {
//     Map<String, CommodityDto> metals = {};
//     json.forEach((key, value) {
//       metals[key] = CommodityDto.fromJson(key, value as Map<String, dynamic>);
//     });
//     return TimeframeDto(timeframe: timeframe, metals: metals);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {timeframe: metals.map((key, value) => MapEntry(key, value.toJson()))};
//   }
//
//   TimeframeEntity toEntity() {
//     return TimeframeEntity(
//       timeframe: timeframe,
//       metals: metals.map((key, value) => MapEntry(key, value.toEntity())),
//     );
//   }
// }
//
// class CommodityDto {
//   final String metal;
//   final Map<String, double> prices;
//
//   CommodityDto({required this.metal, required this.prices});
//
//   factory CommodityDto.fromJson(String metal, Map<String, dynamic> json) {
//     Map<String, double> prices = {};
//     json.forEach((key, value) {
//       if (value != null && value is num) {
//         prices[key] = value.toDouble();
//       }
//     });
//     return CommodityDto(metal: metal, prices: prices);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {metal: prices};
//   }
//
//   CommodityEntity toEntity() {
//     return CommodityEntity(metal: metal, prices: prices);
//   }
// }

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';

// DTO (Data Transfer Object) classes
class CommodityPricesDto {
  final Map<String, MetalDto> metals;

  CommodityPricesDto({required this.metals});

  factory CommodityPricesDto.fromJson(Map<String, dynamic> json) {
    Map<String, MetalDto> metals = {};
    json.forEach((key, value) {
      metals[key] = MetalDto.fromJson(value as Map<String, dynamic>);
    });
    return CommodityPricesDto(metals: metals);
  }

  Map<String, dynamic> toJson() => metals.map((key, value) => MapEntry(key, value.toJson()));

  factory CommodityPricesDto.fromRawJson(String str) => CommodityPricesDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  CommodityPricesEntity toEntity() {
    return CommodityPricesEntity(
      metals: metals.map((key, value) => MapEntry(key, value.toEntity())),
    );
  }
}

class MetalDto {
  final Map<String, List<PricePointDto>> timeframes;

  MetalDto({required this.timeframes});

  factory MetalDto.fromJson(Map<String, dynamic> json) {
    Map<String, List<PricePointDto>> timeframes = {};
    json.forEach((key, value) {
      timeframes[key] = (value as List<dynamic>).map((e) => PricePointDto.fromJson(e as Map<String, dynamic>)).toList();
    });
    return MetalDto(timeframes: timeframes);
  }

  Map<String, dynamic> toJson() => timeframes.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      );

  MetalEntity toEntity() {
    return MetalEntity(
      timeframes: timeframes.map(
        (key, value) => MapEntry(key, value.map((e) => e.toEntity()).toList()),
      ),
    );
  }
}

class PricePointDto {
  final String date;
  final double price;

  PricePointDto({required this.date, required this.price});

  factory PricePointDto.fromJson(Map<String, dynamic> json) => PricePointDto(
        date: json['date'] as String,
        price: json['price'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'price': price,
      };

  PricePointEntity toEntity() => PricePointEntity(date: date, price: price);
}
