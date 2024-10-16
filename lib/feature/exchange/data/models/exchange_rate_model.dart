import 'package:weight_finance/feature/exchange/domain/entities/exchange_rate_entity.dart';
import 'dart:convert';

class ExchangeRateModel {
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

  ExchangeRateModel({
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

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------
  factory ExchangeRateModel.fromRawJson(String str) => ExchangeRateModel.fromMap(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExchangeRateModel.fromMap(Map<String, dynamic> json) {
    return ExchangeRateModel(
      currencyCode: json['cur_unit'],
      countryName: json['cur_nm'],
      buyRate: json['ttb'],
      sellRate: json['tts'],
      baseRate: json['deal_bas_r'],
      bookPrice: json['bkpr'],
      annualExchangeFeeRate: json['yy_efee_r'],
      tenDayExchangeFeeRate: json['ten_dd_efee_r'],
      seoulForeignExchangeBaseRate: json['kftc_deal_bas_r'],
      seoulForeignExchangeBookPrice: json['kftc_bkpr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cur_unit': _currencyCode,
      'cur_nm': _countryName,
      'ttb': _buyRate.toString(),
      'tts': _sellRate.toString(),
      'deal_bas_r': _baseRate.toString(),
      'bkpr': _bookPrice.toString(),
      'yy_efee_r': _annualExchangeFeeRate.toString(),
      'ten_dd_efee_r': _tenDayExchangeFeeRate.toString(),
      'kftc_deal_bas_r': _seoulForeignExchangeBaseRate.toString(),
      'kftc_bkpr': _seoulForeignExchangeBookPrice.toString(),
    };
  }

  Map<String, dynamic> toMap() => {
        'cur_unit': _currencyCode,
        'cur_nm': _countryName,
        'ttb': _buyRate.toString(),
        'tts': _sellRate.toString(),
        'deal_bas_r': _baseRate.toString(),
        'bkpr': _bookPrice.toString(),
        'yy_efee_r': _annualExchangeFeeRate.toString(),
        'ten_dd_efee_r': _tenDayExchangeFeeRate.toString(),
        'kftc_deal_bas_r': _seoulForeignExchangeBaseRate.toString(),
        'kftc_bkpr': _seoulForeignExchangeBookPrice.toString(),
      };

  ExchangeRateEntity toEntity() {
    return ExchangeRateEntity(
      currencyCode: _currencyCode,
      countryName: _countryName,
      buyRate: _buyRate,
      sellRate: _sellRate,
      baseRate: _baseRate,
      bookPrice: _bookPrice,
      annualExchangeFeeRate: _annualExchangeFeeRate,
      tenDayExchangeFeeRate: _tenDayExchangeFeeRate,
      seoulForeignExchangeBaseRate: _seoulForeignExchangeBaseRate,
      seoulForeignExchangeBookPrice: _seoulForeignExchangeBookPrice,
    );
  }
}
