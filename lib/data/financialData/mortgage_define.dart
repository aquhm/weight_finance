import 'package:csv/csv.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/utils/csv_helper.dart';

class MortgageInfo {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String korCoNm;
  final String finPrdtNm;
  final String joinWay;
  final String loanInciExpn;
  final String erlyRpayFee;
  final String dlyRate;
  final String loanLmt;
  final String dclsStrtDay;
  final String dclsEndDay;
  final String finCoSubmDay;

  List<MortgageRate> _rateList = [];

  void addDetails(MortgageRate data) {
    if (finPrdtCd == data.finPrdtCd) {
      _rateList.add(data);
    }
  }

  void clear() {
    _rateList.clear();
  }

  MortgageInfo({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.korCoNm,
    required this.finPrdtNm,
    required this.joinWay,
    required this.loanInciExpn,
    required this.erlyRpayFee,
    required this.dlyRate,
    required this.loanLmt,
    required this.dclsStrtDay,
    required this.dclsEndDay,
    required this.finCoSubmDay,
  });

  factory MortgageInfo.fromList(List<dynamic> row) {
    return MortgageInfo(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      korCoNm: row[3].toString(),
      finPrdtNm: row[4].toString(),
      joinWay: row[5].toString(),
      loanInciExpn: row[6].toString(),
      erlyRpayFee: row[7].toString(),
      dlyRate: row[8].toString(),
      loanLmt: row[9].toString(),
      dclsStrtDay: row[10].toString(),
      dclsEndDay: row[11].toString(),
      finCoSubmDay: row[12].toString(),
    );
  }
}

class MortgageRate {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String mrtgType;
  final String mrtgTypeNm;
  final String rpayType;
  final String rpayTypeNm;
  final String lendRateType;
  final String lendRateTypeNm;
  final String lendRateMin;
  final String lendRateMax;
  final String lendRateAvg;

  MortgageRate({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.mrtgType,
    required this.mrtgTypeNm,
    required this.rpayType,
    required this.rpayTypeNm,
    required this.lendRateType,
    required this.lendRateTypeNm,
    required this.lendRateMin,
    required this.lendRateMax,
    required this.lendRateAvg,
  });

  factory MortgageRate.fromList(List<dynamic> row) {
    return MortgageRate(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      mrtgType: row[3].toString(),
      mrtgTypeNm: row[4].toString(),
      rpayType: row[5].toString(),
      rpayTypeNm: row[6].toString(),
      lendRateType: row[7].toString(),
      lendRateTypeNm: row[8].toString(),
      lendRateMin: row[9].toString(),
      lendRateMax: row[10].toString(),
      lendRateAvg: row[11].toString(),
    );
  }
}

class MortgageData implements FinancialData {
  @override
  String get fileName => 'mortgage.csv';

  final Map<String, MortgageInfo> mortgageInfos;
  final List<MortgageRate> mortgageRates;

  MortgageData({
    required this.mortgageInfos,
    required this.mortgageRates,
  });

  static MortgageData convertFromCsv(String csvContent) {
    List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);

    Map<String, MortgageInfo> mortgageInfos = {};
    List<MortgageRate> mortgageRates = [];

    bool isMortgageInfo = true;
    var isAfterCompanyAreaColumn = false;

    for (var row in rows.skip(1)) {
      if (row.isEmpty) continue;

      if (row[0] == "OptionList") {
        isMortgageInfo = false;
        isAfterCompanyAreaColumn = true;
        continue;
      }

      if (isAfterCompanyAreaColumn == true) {
        isAfterCompanyAreaColumn = false;
        continue;
      }

      if (isMortgageInfo) {
        var data = MortgageInfo.fromList(row);
        mortgageInfos[data.finPrdtCd] = data;
      } else {
        var data = MortgageRate.fromList(row);

        mortgageInfos[data.finPrdtCd]?.addDetails(data);

        mortgageRates.add(data);
      }
    }

    return MortgageData(mortgageInfos: mortgageInfos, mortgageRates: mortgageRates);
  }
}
