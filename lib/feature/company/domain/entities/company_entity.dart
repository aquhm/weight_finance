import 'package:equatable/equatable.dart';
import 'package:weight_finance/feature/company/domain/entities/company_area.dart';

class CompanyEntity extends Equatable {
  final String bankId;
  final String bankName;
  final String websiteUrl;
  final String publicDisclosureManager;
  final String customerServiceTel;

  List<CompanyArea> areaList = [];

  CompanyEntity({
    required this.bankId,
    required this.bankName,
    required this.websiteUrl,
    required this.publicDisclosureManager,
    required this.customerServiceTel,
    required this.areaList,
  });

  @override
  List<Object?> get props => [
        bankId,
        bankName,
        websiteUrl,
        publicDisclosureManager,
        customerServiceTel,
        areaList,
      ];
}
