enum JoinWay {
  branch,
  internet,
  smartphone,
  telephone,
  etc;

  String toDisplayString() {
    switch (this) {
      case JoinWay.branch:
        return '영업점';
      case JoinWay.internet:
        return '인터넷';
      case JoinWay.smartphone:
        return '스마트폰';
      case JoinWay.telephone:
        return '전화(텔레뱅킹)';
      case JoinWay.etc:
      default:
        return '기타';
    }
  }

  static Set<JoinWay> fromString(String value) {
    final ways = value.split(',').map((e) => e.trim().toLowerCase());
    return ways
        .map((way) => switch (way) {
              '영업점' => JoinWay.branch,
              '인터넷' => JoinWay.internet,
              '스마트폰' => JoinWay.smartphone,
              '전화(텔레뱅킹)' => JoinWay.telephone,
              _ => JoinWay.etc,
            })
        .toSet();
  }
}

enum JoinDeny {
  none,
  lowIncome,
  partialRestriction;

  String toDisplayString() {
    switch (this) {
      case JoinDeny.none:
        return '제한 없음';
      case JoinDeny.lowIncome:
        return '저소득';
      case JoinDeny.partialRestriction:
        return '부분 제한';
    }
  }

  static JoinDeny fromString(String value) {
    return switch (value) {
      '1' => JoinDeny.none,
      '2' => JoinDeny.lowIncome,
      '3' => JoinDeny.partialRestriction,
      _ => throw ArgumentError('Unknown join deny value: $value'),
    };
  }
}

enum RateType {
  simple,
  compound;

  static RateType fromString(String value) {
    return switch (value) {
      'S' => RateType.simple,
      'M' => RateType.compound,
      _ => throw ArgumentError('Unknown RateType value: $value'),
    };
  }
}

enum EarningType {
  fixed,
  free;

  static EarningType fromString(String value) {
    return switch (value) {
      'S' => EarningType.fixed,
      'F' => EarningType.free,
      _ => throw ArgumentError('Unknown EarningType value: $value'),
    };
  }
}

enum FinancialType { deposit, saving }
