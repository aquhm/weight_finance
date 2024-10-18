import 'package:equatable/equatable.dart';

class CommodityPricesEntity extends Equatable {
  final Map<String, MetalEntity> metals;

  const CommodityPricesEntity({required this.metals});

  static const List<String> timeFrames = ['5d', '30d', '6m', '1y', '5y', '20y'];

  static String getTimeFrameLabel(String timeFrame) {
    switch (timeFrame) {
      case '5d':
        return '5일';
      case '30d':
        return '1개월';
      case '6m':
        return '6개월';
      case '1y':
        return '1년';
      case '5y':
        return '5년';
      case '20y':
        return '20년';
      default:
        return timeFrame;
    }
  }

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

  double convertPrice(double price, String fromUnit, String toUnit) {
    const conversions = {
      'oz': 1,
      'g': 31.1034768,
      'mg': 31103.4768,
      'kg': 0.0311034768,
      'lb': 0.0685714286,
    };

    return price * conversions[fromUnit]! / conversions[toUnit]!;
  }

  @override
  List<Object?> get props => [date, price];
}
