import 'package:csv/csv.dart';
import 'package:weight_finance/utils/csv_helper.dart';

import 'financial_data.dart';

class CreditInfo {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String crdtPrdtType;
  final String korCoNm;
  final String finPrdtNm;
  final String joinWay;
  final String cbName;
  final String crdtPrdtTypeNm;
  final String dclsStrtDay;
  final String dclsEndDay;
  final String finCoSubmDay;

  List<CreditRate> _rateList = [];

  void addDetails(CreditRate data) {
    if (finPrdtCd == data.finPrdtCd) {
      _rateList.add(data);
    }
  }

  void clear() {
    _rateList.clear();
  }

  CreditInfo({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.crdtPrdtType,
    required this.korCoNm,
    required this.finPrdtNm,
    required this.joinWay,
    required this.cbName,
    required this.crdtPrdtTypeNm,
    required this.dclsStrtDay,
    required this.dclsEndDay,
    required this.finCoSubmDay,
  });

  factory CreditInfo.fromList(List<dynamic> row) {
    return CreditInfo(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      crdtPrdtType: row[3].toString(),
      korCoNm: row[4].toString(),
      finPrdtNm: row[5].toString(),
      joinWay: row[6].toString(),
      cbName: row[7].toString(),
      crdtPrdtTypeNm: row[8].toString(),
      dclsStrtDay: row[9].toString(),
      dclsEndDay: row[10].toString(),
      finCoSubmDay: row[11].toString(),
    );
  }
}

class CreditRate {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String crdtPrdtType;
  final String crdtLendRateType;
  final String crdtLendRateTypeNm;
  final String crdtGrad1;
  final String crdtGrad4;
  final String crdtGrad5;
  final String crdtGrad6;
  final String crdtGrad10;
  final String crdtGrad11;
  final String crdtGrad12;
  final String crdtGrad13;
  final String crdtGradAvg;

  CreditRate({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.crdtPrdtType,
    required this.crdtLendRateType,
    required this.crdtLendRateTypeNm,
    required this.crdtGrad1,
    required this.crdtGrad4,
    required this.crdtGrad5,
    required this.crdtGrad6,
    required this.crdtGrad10,
    required this.crdtGrad11,
    required this.crdtGrad12,
    required this.crdtGrad13,
    required this.crdtGradAvg,
  });

  factory CreditRate.fromList(List<dynamic> row) {
    return CreditRate(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      crdtPrdtType: row[3].toString(),
      crdtLendRateType: row[4].toString(),
      crdtLendRateTypeNm: row[5].toString(),
      crdtGrad1: row[6].toString(),
      crdtGrad4: row[7].toString(),
      crdtGrad5: row[8].toString(),
      crdtGrad6: row[9].toString(),
      crdtGrad10: row[10].toString(),
      crdtGrad11: row[11].toString(),
      crdtGrad12: row[12].toString(),
      crdtGrad13: row[13].toString(),
      crdtGradAvg: row[14].toString(),
    );
  }
}

class CreditData implements FinancialData {
  @override
  String get fileName => 'credit.csv';

  final Map<String, CreditInfo> creditInfos;
  final List<CreditRate> creditRates;

  CreditData({
    required this.creditInfos,
    required this.creditRates,
  });

  static CreditData convertFromCsv(String csvContent) {
    List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);

    Map<String, CreditInfo> creditInfos = {};
    List<CreditRate> creditRates = [];

    bool isCreditInfo = true;
    var isAfterCompanyAreaColumn = false;

    for (var row in rows.skip(1)) {
      if (row.isEmpty) continue;

      if (row[0] == "OptionList") {
        isCreditInfo = false;
        isAfterCompanyAreaColumn = true;
        continue;
      }

      if (isAfterCompanyAreaColumn == true) {
        isAfterCompanyAreaColumn = false;
        continue;
      }

      if (isCreditInfo) {
        var data = CreditInfo.fromList(row);
        creditInfos[data.finPrdtCd] = data;
      } else {
        var data = CreditRate.fromList(row);

        creditInfos[data.finPrdtCd]?.addDetails(data);

        creditRates.add(data);
      }
    }

    return CreditData(creditInfos: creditInfos, creditRates: creditRates);
  }
}
