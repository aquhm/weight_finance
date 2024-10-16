import 'dart:convert';

import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_rate.dart';
import 'package:weight_finance/feature/bank_rate/enum/financial_enums.dart';

class DepositModelDto {
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
  final int? maxLimit;
  final String dclsStrtDay;
  final String? dclsEndDay;
  final String finCoSubmDay;

  final Map<String, DepositRateModelDto> _rateList = {};

  DepositModelDto({
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
  });

  void addDetails(DepositRateModelDto data) {
    if (finPrdtCd == data.finPrdtCd) {
      final type = data.intrRateType;
      final period = data.saveTrm;
      final key = "$type$period";
      _rateList[key] = data;
    }
  }

  factory DepositModelDto.fromRawJson(String str) => DepositModelDto.fromMap(json.decode(str));

  factory DepositModelDto.fromMap(Map<String, dynamic> json) => DepositModelDto(
        dclsMonth: json['dcls_month'],
        finCoNo: json['fin_co_no'],
        finPrdtCd: json['fin_prdt_cd'],
        korCoNm: json['kor_co_nm'],
        finPrdtNm: json['fin_prdt_nm'],
        joinWay: json['join_way'],
        mtrtInt: json['mtrt_int'],
        spclCnd: json['spcl_cnd'],
        joinDeny: json['join_deny'],
        joinMember: json['join_member'],
        etcNote: json['etc_note'],
        maxLimit: json['max_limit'],
        dclsStrtDay: json['dcls_strt_day'],
        dclsEndDay: json['dcls_end_day'],
        finCoSubmDay: json['fin_co_subm_day'],
      );

  Map<String, dynamic> toMap() => {
        'dcls_month': dclsMonth,
        'fin_co_no': finCoNo,
        'fin_prdt_cd': finPrdtCd,
        'kor_co_nm': korCoNm,
        'fin_prdt_nm': finPrdtNm,
        'join_way': joinWay,
        'mtrt_int': mtrtInt,
        'spcl_cnd': spclCnd,
        'join_deny': joinDeny,
        'join_member': joinMember,
        'etc_note': etcNote,
        'max_limit': maxLimit,
        'dcls_strt_day': dclsStrtDay,
        'dcls_end_day': dclsEndDay,
        'fin_co_subm_day': finCoSubmDay,
      };

  String toRawJson() => json.encode(toMap());

  static List<DepositModelDto> fromJsonList(List<Map<String, dynamic>> json) {
    return json?.map((e) => DepositModelDto.fromMap(e)).toList() ?? [];
  }

  Set<JoinWay> get joinWayEnum => JoinWay.fromString(joinWay);
  JoinDeny get joinDenyEnum => JoinDeny.fromString(joinDeny);

  DepositProductEntity toEntity() {
    Map<String, DepositRate> convertedRates = _rateList.map((key, value) => MapEntry(key, value.toEntity()));

    return DepositProductEntity(
      bankId: finCoNo,
      bankName: korCoNm,
      productId: finPrdtCd,
      productName: finPrdtNm,
      maximumAmount: maxLimit ?? 0,
      maturityRate: mtrtInt,
      preferentialTreatment: spclCnd,
      etc: etcNote,
      joinWays: joinWayEnum,
      joinDenyType: joinDenyEnum,
      rates: convertedRates,
    );
  }
}

class DepositRateModelDto {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String intrRateType;
  final String intrRateTypeNm;
  final String saveTrm;
  final double intrRate;
  final double intrRate2;

  DepositRateModelDto({
    required this.dclsMonth,
    required this.finCoNo,
    required this.finPrdtCd,
    required this.intrRateType,
    required this.intrRateTypeNm,
    required this.saveTrm,
    required this.intrRate,
    required this.intrRate2,
  });

  factory DepositRateModelDto.fromRawJson(String str) => DepositRateModelDto.fromMap(json.decode(str));

  factory DepositRateModelDto.fromMap(Map<String, dynamic> json) => DepositRateModelDto(
        dclsMonth: json['dcls_month'],
        finCoNo: json['fin_co_no'],
        finPrdtCd: json['fin_prdt_cd'],
        intrRateType: json['intr_rate_type'],
        intrRateTypeNm: json['intr_rate_type_nm'],
        saveTrm: json['save_trm'],
        intrRate: json['intr_rate']?.toDouble() ?? 0,
        intrRate2: json['intr_rate2']?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'dcls_month': dclsMonth,
        'fin_co_no': finCoNo,
        'fin_prdt_cd': finPrdtCd,
        'intr_rate_type': intrRateType,
        'intr_rate_type_nm': intrRateTypeNm,
        'save_trm': saveTrm,
        'intr_rate': intrRate,
        'intr_rate2': intrRate2,
      };

  String toRawJson() => json.encode(toMap());

  DepositRate toEntity() {
    return DepositRate(
      bankId: finCoNo,
      productId: finPrdtCd,
      interestRateType: intrRateType,
      interestRateTypeName: intrRateTypeNm,
      savingTerm: saveTrm,
      baseInterestRate: intrRate,
      maxPreferentialRate: intrRate2,
    );
  }
}
