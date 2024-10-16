import 'package:flag/flag_enum.dart';

extension FlagsCodeExtension on FlagsCode {
  static FlagsCode fromCurrencyCode(String currencyCode) {
    final Map<String, FlagsCode> codeMap = {
      'AED': FlagsCode.AE,
      'AUD': FlagsCode.AU,
      'BHD': FlagsCode.BH,
      'BND': FlagsCode.BN,
      'CAD': FlagsCode.CA,
      'CHF': FlagsCode.CH,
      'CNH': FlagsCode.CN,
      'DKK': FlagsCode.DK,
      'EUR': FlagsCode.EU,
      'GBP': FlagsCode.GB,
      'HKD': FlagsCode.HK,
      'IDR(100)': FlagsCode.ID,
      'JPY(100)': FlagsCode.JP,
      'KRW': FlagsCode.KR,
      'KWD': FlagsCode.KW,
      'MYR': FlagsCode.MY,
      'NOK': FlagsCode.NO,
      'NZD': FlagsCode.NZ,
      'SAR': FlagsCode.SA,
      'SEK': FlagsCode.SE,
      'SGD': FlagsCode.SG,
      'THB': FlagsCode.TH,
      'USD': FlagsCode.US,
    };

    return codeMap[currencyCode] ?? FlagsCode.NULL;
  }
}
