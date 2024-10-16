import 'dart:convert';

import 'package:weight_finance/extension/null_safety_parsing.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_rate.dart';
import 'package:weight_finance/feature/bank_rate/enum/financial_enums.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_rate.dart';
import 'package:weight_finance/global_api.dart';

class SavingModelDto {
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

  final Map<String, SavingRateModelDto> _rateList = {};

  SavingModelDto({
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

  void addDetails(SavingRateModelDto data) {
    if (finPrdtCd == data.finPrdtCd) {
      final type = data.intrRateType;
      final type1 = data.rsrvType;
      final period = data.saveTrm;
      final key = "$type$type1$period";

      if (_rateList.containsKey(key) == false) {
        _rateList[key] = data;
      }
    }
  }

  factory SavingModelDto.fromRawJson(String str) => SavingModelDto.fromMap(json.decode(str));

  factory SavingModelDto.fromMap(Map<String, dynamic> json) => SavingModelDto(
        dclsMonth: NullSafetyParser.asString(json['dcls_month']),
        finCoNo: NullSafetyParser.asString(json['fin_co_no']),
        finPrdtCd: NullSafetyParser.asString(json['fin_prdt_cd']),
        korCoNm: NullSafetyParser.asString(json['kor_co_nm']),
        finPrdtNm: NullSafetyParser.asString(json['fin_prdt_nm']),
        joinWay: NullSafetyParser.asString(json['join_way']),
        mtrtInt: NullSafetyParser.asString(json['mtrt_int']),
        spclCnd: NullSafetyParser.asString(json['spcl_cnd']),
        joinDeny: NullSafetyParser.asString(json['join_deny']),
        joinMember: NullSafetyParser.asString(json['join_member']),
        etcNote: NullSafetyParser.asString(json['etc_note']),
        maxLimit: NullSafetyParser.asInt(json['max_limit']),
        dclsStrtDay: NullSafetyParser.asString(json['dcls_strt_day']),
        dclsEndDay: NullSafetyParser.asString(json['dcls_end_day']),
        finCoSubmDay: NullSafetyParser.asString(json['fin_co_subm_day']),
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

  static List<SavingModelDto> fromJsonList(List<Map<String, dynamic>> json) {
    return json?.map((e) => SavingModelDto.fromMap(e)).toList() ?? [];
  }

  Set<JoinWay> get joinWayEnum => JoinWay.fromString(joinWay);
  JoinDeny get joinDenyEnum => JoinDeny.fromString(joinDeny);

  SavingProductEntity toEntity() {
    Map<String, SavingRate> convertedRates = _rateList.map((key, value) => MapEntry(key, value.toEntity()));

    return SavingProductEntity(
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

class SavingRateModelDto {
  final String dclsMonth;
  final String finCoNo;
  final String finPrdtCd;
  final String intrRateType;
  final String intrRateTypeNm;
  final String rsrvType;
  final String rsrvTypeNm;
  final String saveTrm;
  final double intrRate;
  final double intrRate2;

  SavingRateModelDto({
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
  });

  factory SavingRateModelDto.fromRawJson(String str) => SavingRateModelDto.fromMap(json.decode(str));

  factory SavingRateModelDto.fromMap(Map<String, dynamic> json) => SavingRateModelDto(
        dclsMonth: NullSafetyParser.asString(json['dcls_month']),
        finCoNo: NullSafetyParser.asString(json['fin_co_no']),
        finPrdtCd: NullSafetyParser.asString(json['fin_prdt_cd']),
        intrRateType: NullSafetyParser.asString(json['intr_rate_type']),
        intrRateTypeNm: NullSafetyParser.asString(json['intr_rate_type_nm']),
        rsrvType: NullSafetyParser.asString(json['rsrv_type']),
        rsrvTypeNm: NullSafetyParser.asString(json['rsrv_type_nm']),
        saveTrm: NullSafetyParser.asString(json['save_trm']),
        intrRate: NullSafetyParser.asDouble(json['intr_rate']),
        intrRate2: NullSafetyParser.asDouble(json['intr_rate2']),
      );

  Map<String, dynamic> toMap() => {
        'dcls_month': dclsMonth,
        'fin_co_no': finCoNo,
        'fin_prdt_cd': finPrdtCd,
        'intr_rate_type': intrRateType,
        'intr_rate_type_nm': intrRateTypeNm,
        'rsrv_type': rsrvType,
        'rsrv_type_nm': rsrvTypeNm,
        'save_trm': saveTrm,
        'intr_rate': intrRate,
        'intr_rate2': intrRate2,
      };

  String toRawJson() => json.encode(toMap());

  SavingRate toEntity() {
    return SavingRate(
      bankId: finCoNo,
      productId: finPrdtCd,
      interestRateType: intrRateType,
      interestRateTypeName: intrRateTypeNm,
      rsrvType: intrRateType,
      rsrvTypeName: intrRateTypeNm,
      savingTerm: saveTrm,
      baseInterestRate: intrRate,
      maxPreferentialRate: intrRate2,
    );
  }
}
