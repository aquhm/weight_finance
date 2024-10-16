import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/company/domain/entities/company_entity.dart';

abstract interface class ICompanyRepository {
  Future<Either<Failure, Map<String, CompanyEntity>>> getCompanies();
}
