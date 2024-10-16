import 'package:csv/csv.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';

import '../../utils/csv_helper.dart';

class AnnuityInfo {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String korCoNm;
  final String finPrdtNm;
  final String joinWay;
  final String pnsnKind;
  final String pnsnKindNm;
  final String saleStrtDay;
  final String mntnCnt;
  final String prdtType;
  final String prdtTypeNm;
  final String avgPrftRate;
  final String dclsRate;
  final String guarRate;
  final String btrmPrftRate1;
  final String btrmPrftRate2;
  final String btrmPrftRate3;
  final String etc;
  final String saleCo;
  final String dclsStrtDay;
  final String dclsEndDay;
  final String finCoSubmDay;

  List<AnnuityDetails> _detailList = [];

  void addDetails(AnnuityDetails data) {
    if (finPrdtCd == data.finPrdtCd) {
      _detailList.add(data);
    }
  }

  void clear() {
    _detailList.clear();
  }

  AnnuityInfo({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.korCoNm,
    required this.finPrdtNm,
    required this.joinWay,
    required this.pnsnKind,
    required this.pnsnKindNm,
    required this.saleStrtDay,
    required this.mntnCnt,
    required this.prdtType,
    required this.prdtTypeNm,
    required this.avgPrftRate,
    required this.dclsRate,
    required this.guarRate,
    required this.btrmPrftRate1,
    required this.btrmPrftRate2,
    required this.btrmPrftRate3,
    required this.etc,
    required this.saleCo,
    required this.dclsStrtDay,
    required this.dclsEndDay,
    required this.finCoSubmDay,
  });

  factory AnnuityInfo.fromList(List<dynamic> row) {
    return AnnuityInfo(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      korCoNm: row[3].toString(),
      finPrdtNm: row[4].toString(),
      joinWay: row[5].toString(),
      pnsnKind: row[6].toString(),
      pnsnKindNm: row[7].toString(),
      saleStrtDay: row[8].toString(),
      mntnCnt: row[9].toString(),
      prdtType: row[10].toString(),
      prdtTypeNm: row[11].toString(),
      avgPrftRate: row[12].toString(),
      dclsRate: row[13].toString(),
      guarRate: row[14].toString(),
      btrmPrftRate1: row[15].toString(),
      btrmPrftRate2: row[16].toString(),
      btrmPrftRate3: row[17].toString(),
      etc: row[18].toString(),
      saleCo: row[19].toString(),
      dclsStrtDay: row[20].toString(),
      dclsEndDay: row[21].toString(),
      finCoSubmDay: row[22].toString(),
    );
  }
}

class AnnuityDetails {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String pnsnRecpTrm;
  final String pnsnRecpTrmNm;
  final String pnsnEntrAge;
  final String pnsnEntrAgeNm;
  final String monPaymAtm;
  final String monPaymAtmNm;
  final String paymPrd;
  final String paymPrdNm;
  final String pnsnStrtAge;
  final String pnsnStrtAgeNm;
  final String pnsnRecpAmt;

  AnnuityDetails({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.pnsnRecpTrm,
    required this.pnsnRecpTrmNm,
    required this.pnsnEntrAge,
    required this.pnsnEntrAgeNm,
    required this.monPaymAtm,
    required this.monPaymAtmNm,
    required this.paymPrd,
    required this.paymPrdNm,
    required this.pnsnStrtAge,
    required this.pnsnStrtAgeNm,
    required this.pnsnRecpAmt,
  });

  factory AnnuityDetails.fromList(List<dynamic> row) {
    return AnnuityDetails(
      dclsMonth: row[0].toString(),
      finCoNo: row[1].toString(),
      finPrdtCd: row[2].toString(),
      pnsnRecpTrm: row[3].toString(),
      pnsnRecpTrmNm: row[4].toString(),
      pnsnEntrAge: row[5].toString(),
      pnsnEntrAgeNm: row[6].toString(),
      monPaymAtm: row[7].toString(),
      monPaymAtmNm: row[8].toString(),
      paymPrd: row[9].toString(),
      paymPrdNm: row[10].toString(),
      pnsnStrtAge: row[11].toString(),
      pnsnStrtAgeNm: row[12].toString(),
      pnsnRecpAmt: row[13].toString(),
    );
  }
}

class AnnuityData implements FinancialData {
  @override
  String get fileName => 'annuity.csv';

  final Map<String, AnnuityInfo> annuityInfos;
  final List<AnnuityDetails> annuityDetails;

  AnnuityData({
    required this.annuityInfos,
    required this.annuityDetails,
  });

  static AnnuityData convertFromCsv(String csvContent) {
    List<List<dynamic>> rows = CsvToListConverter(eol: CsvHelper.getEndOfLine(), shouldParseNumbers: false).convert(csvContent);
    Map<String, AnnuityInfo> annuityInfos = {};
    List<AnnuityDetails> annuityDetails = [];

    bool isAnnuityInfo = true;
    var isAfterCompanyAreaColumn = false;

    for (var row in rows.skip(1)) {
      if (row.isEmpty) continue;

      if (row[0] == "OptionList") {
        isAnnuityInfo = false;
        continue;
      }

      if (isAfterCompanyAreaColumn == true) {
        isAfterCompanyAreaColumn = false;
        continue;
      }

      if (isAnnuityInfo) {
        var data = AnnuityInfo.fromList(row);
        annuityInfos[data.finPrdtCd] = data;
      } else {
        var data = AnnuityDetails.fromList(row);

        annuityInfos[data.finPrdtCd]?.addDetails(data);

        annuityDetails.add(data);
      }
    }

    return AnnuityData(annuityInfos: annuityInfos, annuityDetails: annuityDetails);
  }
}
