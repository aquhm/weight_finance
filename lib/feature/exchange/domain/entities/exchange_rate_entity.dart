import 'package:equatable/equatable.dart';

class ExchangeRateEntity extends Equatable {
  final String? _currencyCode;
  final String? _countryName;
  final String? _buyRate;
  final String? _sellRate;
  final String? _baseRate;
  final String? _bookPrice;
  final String? _annualExchangeFeeRate;
  final String? _tenDayExchangeFeeRate;
  final String? _seoulForeignExchangeBaseRate;
  final String? _seoulForeignExchangeBookPrice;

  const ExchangeRateEntity({
    required String? currencyCode,
    required String? countryName,
    required String? buyRate,
    required String? sellRate,
    required String? baseRate,
    required String? bookPrice,
    required String? annualExchangeFeeRate,
    required String? tenDayExchangeFeeRate,
    required String? seoulForeignExchangeBaseRate,
    required String? seoulForeignExchangeBookPrice,
  })  : _currencyCode = currencyCode,
        _countryName = countryName,
        _buyRate = buyRate,
        _sellRate = sellRate,
        _baseRate = baseRate,
        _bookPrice = bookPrice,
        _annualExchangeFeeRate = annualExchangeFeeRate,
        _tenDayExchangeFeeRate = tenDayExchangeFeeRate,
        _seoulForeignExchangeBaseRate = seoulForeignExchangeBaseRate,
        _seoulForeignExchangeBookPrice = seoulForeignExchangeBookPrice;

  String? get currencyCode => _currencyCode;
  String? get countryName => _countryName;
  String? get buyRate => _buyRate;
  String? get sellRate => _sellRate;
  String? get baseRate => _baseRate;
  String? get bookPrice => _bookPrice;
  String? get annualExchangeFeeRate => _annualExchangeFeeRate;
  String? get tenDayExchangeFeeRate => _tenDayExchangeFeeRate;
  String? get seoulForeignExchangeBaseRate => _seoulForeignExchangeBaseRate;
  String? get seoulForeignExchangeBookPrice => _seoulForeignExchangeBookPrice;

  @override
  List<Object?> get props {
    return [
      _currencyCode,
      _countryName,
      _buyRate,
      _sellRate,
      _baseRate,
      _bookPrice,
      _annualExchangeFeeRate,
      _tenDayExchangeFeeRate,
      _seoulForeignExchangeBaseRate,
      _seoulForeignExchangeBookPrice,
    ];
  }
}
