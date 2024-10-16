import 'package:csv/csv.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/utils/csv_helper.dart';

class SavingInfo implements FinancialInfo {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String korCoNm;
  final String finPrdtNm;
  final String joinWay;
  final String mtrtInt;
  final String spclCnd;
  final String joinDeny;
  final String joinMember;
  final String etcNote;
  final String maxLimit;
  final String dclsStrtDay;
  final String dclsEndDay;
  final String finCoSubmDay;

  final Set<JoinWay> _joinWays;
  final JoinDeny _joinDenyType;

  Map<String, SavingRate> _rateList = {};

  List<MapEntry<String, SavingRate>> _getRateList({String prefix = 'S'}) {
    var filteredRates = _rateList.entries.where((entry) => entry.key.startsWith(prefix)).toList();

    return filteredRates;
  }

  void addDetails(SavingRate data) {
    if (finPrdtCd == data.finPrdtCd) {
      final type = data.intrRateType;
      final type1 = data.rsrvType;
      final period = data.saveTrm;
      final key = "$type$type1$period";

      if (_rateList.containsKey(key) == false) {
        GlobalAPI.logger.d("addDetails key = {key}");
        _rateList[key] = data;
      }
    }
  }

  void clear() {
    _rateList.clear();
  }

  SavingInfo({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.korCoNm,
    required this.finPrdtNm,
    required this.joinWay,
    required this.mtrtInt,
    required this.spclCnd,
    required this.joinDeny,
    required this.joinMember,
    required this.etcNote,
    required this.maxLimit,
    required this.dclsStrtDay,
    required this.dclsEndDay,
    required this.finCoSubmDay,
  })  : this._joinWays = JoinWay.fromString(joinWay),
        this._joinDenyType = JoinDeny.fromString(joinDeny);

  factory SavingInfo.fromList(List<dynamic> row) {
    return SavingInfo(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      korCoNm: row[3].toString(),
      finPrdtNm: row[4].toString(),
      joinWay: row[5].toString(),
      mtrtInt: row[6].toString(),
      spclCnd: row[7].toString(),
      joinDeny: row[8].toString(),
      joinMember: row[9].toString(),
      etcNote: row[10].toString(),
      maxLimit: row[11].toString(),
      dclsStrtDay: row[12].toString(),
      dclsEndDay: row[13].toString(),
      finCoSubmDay: row[14].toString(),
    );
  }

  @override
  double getRate(int month) {
    List<String> keys = ['SS$month', 'SF$month', 'MS$month', 'MF$month'];

    List<double> rates = keys.map((key) => _rateList[key]?.defaultRate).whereType<double>().toList();

    return rates.isEmpty ? 0 : rates.reduce((a, b) => a > b ? a : b);
  }

  @override
  FinancialRate? getRateData(int month) {
    List<String> generateKeys(int month) {
      return ['SS$month', 'SF$month', 'MS$month', 'MF$month'];
    }

    List<FinancialRate> rates = generateKeys(month).map((key) => _rateList[key]).whereType<FinancialRate>().toList();

    if (rates.isEmpty) {
      return null;
    }

    return rates.reduce((curr, next) => curr.defaultRate > next.defaultRate ? curr : next);
  }

  @override
  String get bankName => korCoNm;

  @override
  String get productName => finPrdtNm;

  @override
  String get bankId => finCoNo;

  @override
  JoinDeny get joinDenyType => _joinDenyType;

  @override
  Set<JoinWay> get joinWays => _joinWays;

  @override
  String get etc => etcNote;

  @override
  String get maturityRate => mtrtInt;

  @override
  int get maximumAmount => int.tryParse(maxLimit) ?? 0;

  @override
  String get preferentialTreatment => spclCnd;

  @override
  Map<String, FinancialRate> get rateList => _rateList;

  @override
  List<MapEntry<String, FinancialRate>> get compoundRateList {
    return _getRateList(prefix: "M");
  }

  @override
  List<MapEntry<String, FinancialRate>> get simpleRateList {
    return _getRateList(prefix: "S");
  }

  @override
  FinancialType get financialType => FinancialType.saving;
}

class SavingRate implements FinancialRate {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String intrRateType;
  final String intrRateTypeNm;
  final String rsrvType;
  final String rsrvTypeNm;
  final String saveTrm;
  final String intrRate;
  final String intrRate2;

  late int _month;
  late double _defaultRate;
  late double _preferentialRate;

  SavingRate({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.intrRateType,
    required this.intrRateTypeNm,
    required this.rsrvType,
    required this.rsrvTypeNm,
    required this.saveTrm,
    required this.intrRate,
    required this.intrRate2,
  }) {
    _month = int.tryParse(saveTrm) ?? 0;
    _defaultRate = double.tryParse(intrRate) ?? 0;
    _preferentialRate = double.tryParse(intrRate2) ?? 0;
  }

  factory SavingRate.fromList(List<dynamic> row) {
    return SavingRate(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      intrRateType: row[3].toString(),
      intrRateTypeNm: row[4].toString(),
      rsrvType: row[5].toString(),
      rsrvTypeNm: row[6].toString(),
      saveTrm: row[7].toString(),
      intrRate: row[8].toString(),
      intrRate2: row[9].toString(),
    );
  }

  @override
  double get defaultRate => _defaultRate;

  @override
  int get month => _month;

  @override
  double get preferentialRate => _preferentialRate;
}

class SavingData implements FinancialData {
  @override
  String get fileName => 'saving.csv';

  final Map<FinancialKey, SavingInfo> savingInfos;
  final List<SavingRate> savingRates;

  SavingData({
    required this.savingInfos,
    required this.savingRates,
  });

  static SavingData convertFromCsv(String csvContent) {
    List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);
    Map<FinancialKey, SavingInfo> savingInfos = {};
    List<SavingRate> savingRates = [];

    bool isSavingInfo = true;
    var isAfterCompanyAreaColumn = false;

    for (var row in rows.skip(1)) {
      if (row.isEmpty) continue;

      if (row[0] == "OptionList") {
        isSavingInfo = false;
        isAfterCompanyAreaColumn = true;
        continue;
      }

      if (isAfterCompanyAreaColumn == true) {
        isAfterCompanyAreaColumn = false;
        continue;
      }

      if (isSavingInfo) {
        var data = SavingInfo.fromList(row);
        final key = FinancialKey(data.finCoNo, data.finPrdtCd);

        if (savingInfos.containsKey(key) == false) {
          savingInfos[key] = data;
        }
      } else {
        var data = SavingRate.fromList(row);

        final key = FinancialKey(data.finCoNo, data.finPrdtCd);

        if (savingInfos.containsKey(key)) {
          savingInfos[key]?.addDetails(data);
        }

        savingRates.add(data);
      }
    }

    return SavingData(savingInfos: savingInfos, savingRates: savingRates);
  }
}
