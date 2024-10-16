import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/feature/company/data/models/company_model.dart';

abstract interface class ICompanyApi {
  Future<Either<Failure, Map<String, CompanyModelDto>>> getCompanies();
}
