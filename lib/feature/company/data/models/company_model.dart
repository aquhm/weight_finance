import 'dart:convert';

import 'package:weight_finance/feature/company/domain/entities/company_area.dart';
import 'package:weight_finance/feature/company/domain/entities/company_entity.dart';

class CompanyModelDto {
  final String dclsMonth;
  final String finCoNo;
  final String korCoNm;
  final String dclsChrgMan;
  final String hompUrl;
  final String calTel;

  List<CompanyAreaModelDto> _areaList = [];

  CompanyModelDto({
    required this.dclsMonth,
    required this.finCoNo,
    required this.korCoNm,
    required this.dclsChrgMan,
    required this.hompUrl,
    required this.calTel,
  });

  void addArea(CompanyAreaModelDto data) {
    if (finCoNo == data.finCoNo) {
      _areaList.add(data);
    }
  }

  void clear() {
    _areaList.clear();
  }

  factory CompanyModelDto.fromRawJson(String str) => CompanyModelDto.fromMap(json.decode(str));

  factory CompanyModelDto.fromMap(Map<String, dynamic> json) => CompanyModelDto(
        dclsMonth: json['dcls_month'],
        finCoNo: json['fin_co_no'],
        korCoNm: json['kor_co_nm'],
        dclsChrgMan: json['dcls_chrg_man'],
        hompUrl: json['homp_url'],
        calTel: json['cal_tel'],
      );

  Map<String, dynamic> toMap() => {
        'dcls_month': dclsMonth,
        'fin_co_no': finCoNo,
        'kor_co_nm': korCoNm,
        'dcls_chrg_man': dclsChrgMan,
        'homp_url': hompUrl,
        'cal_tel': calTel,
      };

  String toRawJson() => json.encode(toMap());

  static List<CompanyModelDto> fromJsonList(List<dynamic> json) {
    return json?.map((e) => CompanyModelDto.fromMap(e)).toList() ?? [];
  }

  CompanyEntity toEntity() {
    List<CompanyArea> areaList = _areaList.map((e) => e.toEntity()).toList();

    return CompanyEntity(
        bankId: finCoNo,
        bankName: korCoNm,
        websiteUrl: hompUrl,
        publicDisclosureManager: dclsChrgMan,
        customerServiceTel: calTel,
        areaList: areaList);
  }
}

class CompanyAreaModelDto {
  final String dclsMonth;
  final String finCoNo;
  final String areaCd;
  final String areaNm;
  final String exisYn;

  CompanyAreaModelDto({
    required this.dclsMonth,
    required this.finCoNo,
    required this.areaCd,
    required this.areaNm,
    required this.exisYn,
  });

  factory CompanyAreaModelDto.fromRawJson(String str) => CompanyAreaModelDto.fromMap(json.decode(str));

  factory CompanyAreaModelDto.fromMap(Map<String, dynamic> json) => CompanyAreaModelDto(
        dclsMonth: json['dcls_month'],
        finCoNo: json['fin_co_no'],
        areaCd: json['area_cd'],
        areaNm: json['area_nm'],
        exisYn: json['exis_yn'],
      );

  Map<String, dynamic> toMap() => {
        'dcls_month': dclsMonth,
        'fin_co_no': finCoNo,
        'area_cd': areaCd,
        'area_nm': areaNm,
        'exis_yn': exisYn,
      };

  String toRawJson() => json.encode(toMap());

  CompanyArea toEntity() {
    return CompanyArea(
      dclsMonth: dclsMonth,
      finCoNo: finCoNo,
      areaCd: areaCd,
      areaNm: areaNm,
      exisYn: exisYn,
    );
  }
}
