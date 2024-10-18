import 'dart:convert';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';

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
