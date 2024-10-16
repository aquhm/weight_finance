// import 'dart:math';
//
// import 'package:csv/csv.dart';
// import 'package:weight_finance/data/financialData/financial_data.dart';
// import 'package:weight_finance/utils/csv_helper.dart';
//
// class DepositInfo implements FinancialInfo {
//   final String dclsMonth;
//   final String finCoNo;
//   final String finPrdtCd;
//   final String korCoNm;
//   final String finPrdtNm;
//   final String joinWay;
//   final String mtrtInt;
//   final String spclCnd;
//   final String joinDeny;
//   final String joinMember;
//   final String etcNote;
//   final String maxLimit;
//   final String dclsStrtDay;
//   final String dclsEndDay;
//   final String finCoSubmDay;
//
//   final Set<JoinWay> _joinWays;
//   final JoinDeny _joinDenyType;
//
//   Map<String, DepositRate> _rateList = {};
//
//   List<MapEntry<String, DepositRate>> _getRateList({String prefix = 'S'}) {
//     var filteredRates = _rateList.entries.where((entry) => entry.key.startsWith(prefix)).toList();
//
//     return filteredRates;
//   }
//
//   void addDetails(DepositRate data) {
//     if (finPrdtCd == data.finPrdtCd) {
//       final type = data.intrRateType;
//       final period = data.saveTrm;
//       final key = "$type$period";
//       _rateList[key] = data;
//     }
//   }
//
//   @override
//   String get bankId => finCoNo;
//
//   @override
//   JoinDeny get joinDenyType => _joinDenyType;
//
//   @override
//   Set<JoinWay> get joinWays => _joinWays;
//
//   @override
//   String get bankName => korCoNm;
//
//   @override
//   String get productName => finPrdtNm;
//
//   @override
//   String get etc => etcNote;
//
//   @override
//   String get maturityRate => mtrtInt;
//
//   @override
//   int get maximumAmount => int.tryParse(maxLimit) ?? 0;
//
//   @override
//   String get preferentialTreatment => spclCnd;
//
//   @override
//   List<MapEntry<String, FinancialRate>> get compoundRateList {
//     return _getRateList(prefix: "M");
//   }
//
//   @override
//   List<MapEntry<String, FinancialRate>> get simpleRateList {
//     return _getRateList(prefix: "S");
//   }
//
//   @override
//   double getRate(int month) {
//     List<String> keys = ['S$month', 'M$month'];
//
//     List<double> rates = keys.map((key) => _rateList[key]?.defaultRate).whereType<double>().toList();
//
//     return rates.isEmpty ? 0 : rates.reduce((a, b) => a > b ? a : b);
//   }
//
//   @override
//   FinancialRate? getRateData(int month) {
//     List<String> generateKeys(int month) {
//       return ['S$month', 'M$month'];
//     }
//
//     List<FinancialRate> rates = generateKeys(month).map((key) => _rateList[key]).whereType<FinancialRate>().toList();
//
//     if (rates.isEmpty) {
//       return null;
//     }
//
//     return rates.reduce((curr, next) => curr.defaultRate > next.defaultRate ? curr : next);
//   }
//
//   void clear() {
//     _rateList.clear();
//   }
//
//   DepositInfo({
//     required this.dclsMonth,
//     required this.finCoNo,
//     required this.finPrdtCd,
//     required this.korCoNm,
//     required this.finPrdtNm,
//     required this.joinWay,
//     required this.mtrtInt,
//     required this.spclCnd,
//     required this.joinDeny,
//     required this.joinMember,
//     required this.etcNote,
//     required this.maxLimit,
//     required this.dclsStrtDay,
//     required this.dclsEndDay,
//     required this.finCoSubmDay,
//   })  : this._joinWays = JoinWay.fromString(joinWay),
//         this._joinDenyType = JoinDeny.fromString(joinDeny);
//
//   factory DepositInfo.fromList(List<dynamic> row) {
//     return DepositInfo(
//       dclsMonth: row[0].toString(),
//       finCoNo: row[1].toString(),
//       finPrdtCd: row[2].toString(),
//       korCoNm: row[3].toString(),
//       finPrdtNm: row[4].toString(),
//       joinWay: row[5].toString(),
//       mtrtInt: row[6].toString(),
//       spclCnd: row[7].toString(),
//       joinDeny: row[8].toString(),
//       joinMember: row[9].toString(),
//       etcNote: row[10].toString(),
//       maxLimit: row[11].toString(),
//       dclsStrtDay: row[12].toString(),
//       dclsEndDay: row[13].toString(),
//       finCoSubmDay: row[14].toString(),
//     );
//   }
//
//   @override
//   FinancialType get financialType => FinancialType.deposit;
// }
//
// class DepositRate implements FinancialRate {
//   final String dclsMonth;
//   final String finCoNo;
//   final String finPrdtCd;
//   final String intrRateType;
//   final String intrRateTypeNm;
//   final String saveTrm;
//   final String intrRate;
//   final String intrRate2;
//
//   late int _month;
//   late double _defaultRate;
//   late double _preferentialRate;
//
//   DepositRate({
//     required this.dclsMonth,
//     required this.finCoNo,
//     required this.finPrdtCd,
//     required this.intrRateType,
//     required this.intrRateTypeNm,
//     required this.saveTrm,
//     required this.intrRate,
//     required this.intrRate2,
//   }) {
//     _month = int.tryParse(saveTrm) ?? 0;
//     _defaultRate = double.tryParse(intrRate) ?? 0;
//     _preferentialRate = double.tryParse(intrRate2) ?? 0;
//   }
//
//   factory DepositRate.fromList(List<dynamic> row) {
//     return DepositRate(
//       dclsMonth: row[0].toString(),
//       finCoNo: row[1].toString(),
//       finPrdtCd: row[2].toString(),
//       intrRateType: row[3].toString(),
//       intrRateTypeNm: row[4].toString(),
//       saveTrm: row[5].toString(),
//       intrRate: row[6].toString(),
//       intrRate2: row[7].toString(),
//     );
//   }
//
//   @override
//   double get defaultRate => _defaultRate;
//
//   @override
//   int get month => _month;
//
//   @override
//   double get preferentialRate => _preferentialRate;
// }
//
// class DepositData implements FinancialData {
//   @override
//   String get fileName => 'deposit.csv';
//
//   final Map<FinancialKey, DepositInfo> depositInfos;
//   final List<DepositRate> depositRates;
//
//   DepositData({
//     required this.depositInfos,
//     required this.depositRates,
//   });
//
//   static DepositData convertFromCsv(String csvContent) {
//     List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);
//
//     Map<FinancialKey, DepositInfo> depositInfos = {};
//     List<DepositRate> depositRates = [];
//
//     bool isDepositInfo = true;
//     var isAfterCompanyAreaColumn = false;
//
//     for (var row in rows.skip(1)) {
//       if (row.isEmpty) continue;
//
//       if (row[0] == "OptionList") {
//         isDepositInfo = false;
//         isAfterCompanyAreaColumn = true;
//         continue;
//       }
//
//       if (isAfterCompanyAreaColumn == true) {
//         isAfterCompanyAreaColumn = false;
//         continue;
//       }
//
//       if (isDepositInfo) {
//         var data = DepositInfo.fromList(row);
//
//         final key = FinancialKey(data.finCoNo, data.finPrdtCd);
//         if (depositInfos.containsKey(key) == false) {
//           depositInfos[key] = data;
//         }
//       } else {
//         var data = DepositRate.fromList(row);
//
//         final key = FinancialKey(data.finCoNo, data.finPrdtCd);
//
//         if (depositInfos.containsKey(key)) {
//           depositInfos[key]?.addDetails(data);
//         }
//
//         depositRates.add(data);
//       }
//     }
//
//     return DepositData(depositInfos: depositInfos, depositRates: depositRates);
//   }
// }
