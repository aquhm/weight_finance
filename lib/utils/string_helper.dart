import 'package:intl/intl.dart';

extension StringExtensions on String {
  String removeNewlines() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String formatKoreanWon(int amount) {
    final formatter = NumberFormat('#,###원', 'ko_KR');
    return formatter.format(amount);
  }

  String extractNumber() {
    final match = RegExp(r'\d+').firstMatch(this);
    if (match != null) {
      return match.group(0) ?? '';
    } else {
      print('Warning: Unable to extract number from string: $this');
      return '';
    }
  }
}
