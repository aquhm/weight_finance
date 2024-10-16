import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _koreanWonFormatter = NumberFormat('#,###원', 'ko_KR');

  static String formatKoreanWon(int amount, {bool symbol = true}) {
    if (symbol) {
      return _koreanWonFormatter.format(amount);
    } else {
      return _koreanWonFormatter.format(amount).replaceAll('원', '');
    }
  }

  static String formatKoreanWonFromDouble(double amount, {bool symbol = true}) {
    return formatKoreanWon(amount.round(), symbol: symbol);
  }
}
