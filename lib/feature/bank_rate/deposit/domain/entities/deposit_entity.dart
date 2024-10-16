import 'package:equatable/equatable.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_rate.dart';
import 'package:weight_finance/feature/bank_rate/enum/financial_enums.dart';

class DepositProductEntity extends Equatable implements FinancialProduct {
  @override
  final String bankId;
  @override
  final String bankName;
  @override
  final String productId;
  @override
  final String productName;
  @override
  final int maximumAmount;
  @override
  final String maturityRate;
  @override
  final String preferentialTreatment;
  @override
  final String etc;
  @override
  final Set<JoinWay> joinWays;
  @override
  final JoinDeny joinDenyType;

  @override
  Map<String, FinancialRate> rates;

  DepositProductEntity({
    required this.bankId,
    required this.bankName,
    required this.productId,
    required this.productName,
    required this.maximumAmount,
    required this.maturityRate,
    required this.preferentialTreatment,
    required this.etc,
    required this.joinWays,
    required this.joinDenyType,
    required this.rates,
  });

  @override
  double getRate(int month) {
    List<String> keys = ['S$month', 'M$month'];
    List<double> rateValues = keys.map((key) => rates[key]?.defaultRate).whereType<double>().toList();
    return rateValues.isEmpty ? 0 : rateValues.reduce((a, b) => a > b ? a : b);
  }

  @override
  FinancialRate? getRateData(int month) {
    List<String> keys = ['S$month', 'M$month'];
    List<FinancialRate> rateValues = keys.map((key) => rates[key]).whereType<FinancialRate>().toList();
    return rateValues.isEmpty ? null : rateValues.reduce((curr, next) => curr.defaultRate > next.defaultRate ? curr : next);
  }

  @override
  List<MapEntry<String, FinancialRate>> get compoundRateList {
    return _getRateList(prefix: "M");
  }

  @override
  List<MapEntry<String, FinancialRate>> get simpleRateList {
    return _getRateList(prefix: "S");
  }

  @override
  List<Object?> get props => [
        bankId,
        bankName,
        productName,
        maximumAmount,
        maturityRate,
        preferentialTreatment,
        etc,
        joinWays,
        joinDenyType,
        rates,
      ];

  List<MapEntry<String, FinancialRate>> _getRateList({String prefix = 'S'}) {
    var filteredRates = rates.entries.where((entry) => entry.key.startsWith(prefix)).toList();

    return filteredRates;
  }

  FinancialRate? getDefaultRateData() {
    var rate12Month = getRateData(12);
    if (rate12Month != null) {
      return rate12Month;
    }

    List<FinancialRate> allRates = rates.values.toList();

    if (allRates.isEmpty) {
      return null;
    }

    if (allRates.length == 1) {
      return allRates.first;
    }

    allRates.sort((a, b) => a.month.compareTo(b.month));

    int middleIndex = allRates.length ~/ 2;
    return allRates[middleIndex];
  }
}
