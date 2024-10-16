import 'package:weight_finance/feature/bank_rate/common/financial_rate.dart';

class DepositRate implements FinancialRate {
  /// 금융 회사 번호
  final String bankId;

  /// 금융 상품 코드
  final String productId;

  /// 저축 금리 유형 (예: 'S' for 단리, 'M' for 복리)
  final String interestRateType;

  /// 저축 금리 유형명 (예: '단리', '복리')
  final String interestRateTypeName;

  /// 저축 기간 (단위: 개월)
  final String savingTerm;

  /// 기본 저축 금리 (단위: %, 소수점 2자리)
  final double baseInterestRate;

  /// 최고 우대 금리 (단위: %, 소수점 2자리)
  final double maxPreferentialRate;

  late int _termInMonths;
  late double _baseRate;
  late double _preferentialRate;

  DepositRate({
    required this.bankId,
    required this.productId,
    required this.interestRateType,
    required this.interestRateTypeName,
    required this.savingTerm,
    required this.baseInterestRate,
    required this.maxPreferentialRate,
  }) {
    _termInMonths = int.tryParse(savingTerm) ?? 0;
    _baseRate = baseInterestRate;
    _preferentialRate = maxPreferentialRate;
  }

  @override
  double get defaultRate => _baseRate;

  @override
  int get month => _termInMonths;

  @override
  double get preferentialRate => _preferentialRate;

  /// 복리 여부를 반환
  bool get isCompoundInterest => interestRateType == 'M';

  /// 단리 여부를 반환
  bool get isSimpleInterest => interestRateType == 'S';

  @override
  String toString() {
    return 'DepositRate(term: $savingTerm months, baseRate: $baseInterestRate%, maxRate: $maxPreferentialRate%, type: $interestRateTypeName)';
  }
}
