import 'package:csv/csv.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/utils/csv_helper.dart';

class RentInfo {
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

  List<RentRate> _rateList = [];

  void addDetails(RentRate data) {
    if (finPrdtCd == data.finPrdtCd) {
      _rateList.add(data);
    }
  }

  void clear() {
    _rateList.clear();
  }

  RentInfo({
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

  factory RentInfo.fromList(List<dynamic> row) {
    return RentInfo(
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

class RentRate {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String rpayType;
  final String rpayTypeNm;
  final String lendRateType;
  final String lendRateTypeNm;
  final String lendRateMin;
  final String lendRateMax;
  final String lendRateAvg;

  RentRate({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.rpayType,
    required this.rpayTypeNm,
    required this.lendRateType,
    required this.lendRateTypeNm,
    required this.lendRateMin,
    required this.lendRateMax,
    required this.lendRateAvg,
  });

  factory RentRate.fromList(List<dynamic> row) {
    return RentRate(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      rpayType: row[3].toString(),
      rpayTypeNm: row[4].toString(),
      lendRateType: row[5].toString(),
      lendRateTypeNm: row[6].toString(),
      lendRateMin: row[7].toString(),
      lendRateMax: row[8].toString(),
      lendRateAvg: row[9].toString(),
    );
  }
}

class RentData implements FinancialData {
  // Define rent-specific fields
  @override
  String get fileName => 'rent.csv';

  final Map<String, RentInfo> rentInfos;
  final List<RentRate> rentRates;

  RentData({
    required this.rentInfos,
    required this.rentRates,
  });

  static RentData convertFromCsv(String csvContent) {
    List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);
    Map<String, RentInfo> rentInfos = {};
    List<RentRate> rentRates = [];

    bool isRentInfo = true;
    var isAfterCompanyAreaColumn = false;

    for (var row in rows.skip(1)) {
      if (row.isEmpty) continue;

      if (row[0] == "OptionList") {
        isRentInfo = false;
        isAfterCompanyAreaColumn = true;
        continue;
      }

      if (isAfterCompanyAreaColumn == true) {
        isAfterCompanyAreaColumn = false;
        continue;
      }

      if (isRentInfo) {
        var data = RentInfo.fromList(row);
        rentInfos[data.finPrdtCd] = data;
      } else {
        var data = RentRate.fromList(row);

        rentInfos[data.finPrdtCd]?.addDetails(data);

        rentRates.add(data);
      }
    }

    return RentData(rentInfos: rentInfos, rentRates: rentRates);
  }
}
