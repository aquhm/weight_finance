import 'package:weight_finance/feature/bank_rate/common/financial_rate.dart';
import 'package:weight_finance/feature/bank_rate/enum/financial_enums.dart';

abstract class FinancialProduct {
  String get bankId;
  String get bankName;
  String get productId;
  String get productName;
  int get maximumAmount;
  String get maturityRate;
  String get preferentialTreatment;
  String get etc;
  Set<JoinWay> get joinWays;
  JoinDeny get joinDenyType;
  FinancialRate? getRateData(int month);
  double getRate(int month);

  FinancialRate? getDefaultRateData();

  Map<String, FinancialRate> rates = {};

  List<MapEntry<String, FinancialRate>> get simpleRateList; // 이자율 리스트
  List<MapEntry<String, FinancialRate>> get compoundRateList; // 이자율 리스트
}
