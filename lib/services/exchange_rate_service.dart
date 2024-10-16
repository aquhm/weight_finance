import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';
import 'package:weight_finance/services/base_service.dart';

class ExchangeRateService implements IService {
  late final String _apiUrl;

  Map<String, List<List<dynamic>>> _cachedData = {};

  @override
  void clear() {
    _cachedData.clear();
  }

  @override
  void dispose() {
    clear();
  }

  @override
  void init() {
    _apiUrl = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=VA0r2YNuhLbZnursfysP47YooJtpOxBN&data=AP01";
  }
}
