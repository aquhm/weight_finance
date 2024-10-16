import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'dart:math' as math;

class FinanceDetailController extends GetxController {
  static const double minAmount = 1000000;
  static const double maxAmount = 100000000;

  Rx<FinancialInfo?> financialInfo = Rx<FinancialInfo?>(null);

  final RxDouble depositAmount = RxDouble(maxAmount / 2);

  final RxBool isCompound = RxBool(false);

  final RxDouble calculatedInterest = RxDouble(0.0);

  @override
  void onInit() {
    super.onInit();
    isCompound.value = false;
  }

  void initialize() {
    isCompound.value = false;
  }

  void setFinancialInfo(FinancialInfo info) {
    financialInfo.value = info;
    // 필요한 초기화 로직 수행
    initializeWithFinancialInfo(info);
  }

  void initializeWithFinancialInfo(FinancialInfo info) {
    financialInfo.value = info;
  }

  void toggleInterestType() {
    isCompound.value = !isCompound.value;
  }

  void updateDepositAmount(double value) {
    int roundedValue = (value / 1000000).round() * 1000000;
    depositAmount.value = roundedValue.toDouble().clamp(minAmount, maxAmount);
  }

  List<MapEntry<String, FinancialRate>> get currentRateList {
    var compoundRateList = financialInfo.value?.compoundRateList ?? [];
    var simpleRateList = financialInfo.value?.simpleRateList ?? [];

    switch (financialInfo.value?.financialType) {
      case FinancialType.deposit:
        return isCompound.value ? compoundRateList : simpleRateList;
      case FinancialType.saving:
        if (isCompound.value) {
          return compoundRateList.isNotEmpty ? compoundRateList : simpleRateList;
        } else {
          return simpleRateList.isNotEmpty ? simpleRateList : compoundRateList;
        }
      default:
        return isCompound.value ? compoundRateList : simpleRateList;
    }
  }
}
