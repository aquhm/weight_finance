import 'dart:io';

import 'package:csv/csv.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/utils/csv_helper.dart';

class CompanyInfo {
  final String dclsMonth;
  final String finCoNo;
  final String korCoNm;
  final String dclsChrgMan;
  final String hompUrl;
  final String calTel;

  List<CompanyArea> _areaList = [];

  void addArea(CompanyArea data) {
    if (finCoNo == data.finCoNo) {
      _areaList.add(data);
    }
  }

  void clear() {
    _areaList.clear();
  }

  CompanyInfo({
    required this.dclsMonth,
    required this.finCoNo,
    required this.korCoNm,
    required this.dclsChrgMan,
    required this.hompUrl,
    required this.calTel,
  });

  factory CompanyInfo.fromList(List<dynamic> row) {
    return CompanyInfo(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      korCoNm: row[2].toString(),
      dclsChrgMan: row[3].toString(),
      hompUrl: row[4].toString(),
      calTel: row[5].toString(),
    );
  }
}

class CompanyArea {
  final String dclsMonth;
  final String finCoNo;
  final String areaCd;
  final String areaNm;
  final String exisYn;

  CompanyArea({
    required this.dclsMonth,
    required this.finCoNo,
    required this.areaCd,
    required this.areaNm,
    required this.exisYn,
  });

  factory CompanyArea.fromList(List<dynamic> row) {
    return CompanyArea(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      areaCd: row[2].toString(),
      areaNm: row[3].toString(),
      exisYn: row[4].toString(),
    );
  }
}

class CompanyData implements FinancialData {
  @override
  String get fileName => 'company.csv';

  final Map<String, CompanyInfo> companyInfos;
  final List<CompanyArea> companyAreas;

  CompanyData({
    required this.companyInfos,
    required this.companyAreas,
  });

  static CompanyData convertFromCsv(String csvContent) {
    List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);
    Map<String, CompanyInfo> companyInfos = {};
    List<CompanyArea> companyAreas = [];

    bool isCompanyInfo = true;
    var isAfterCompanyAreaColumn = false;

    for (var row in rows.skip(1)) {
      if (row.isEmpty) continue;

      if (row[0] == "OptionList") {
        isCompanyInfo = false;
        isAfterCompanyAreaColumn = true;
        continue;
      }

      if (isAfterCompanyAreaColumn == true) {
        isAfterCompanyAreaColumn = false;
        continue;
      }

      if (isCompanyInfo) {
        var data = CompanyInfo.fromList(row);
        companyInfos[data.finCoNo] = data;
      } else {
        var data = CompanyArea.fromList(row);

        companyInfos[data.finCoNo]?.addArea(data);

        companyAreas.add(CompanyArea.fromList(row));
      }
    }

    return CompanyData(companyInfos: companyInfos, companyAreas: companyAreas);
  }
}
