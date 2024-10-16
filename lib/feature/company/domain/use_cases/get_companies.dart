import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/company/domain/entities/company_entity.dart';
import 'package:weight_finance/feature/company/domain/repositories/company_repository.dart';

class GetCompaniesUseCase implements UseCase {
  final ICompanyRepository repository;

  const GetCompaniesUseCase({required this.repository});

  @override
  Future<Either<Failure, Map<String, CompanyEntity>>> call(params) async {
    return await repository.getCompanies();
  }
}
