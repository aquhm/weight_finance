import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/company/data/data_sources/remote/abstract_company_api.dart';
import 'package:weight_finance/feature/company/domain/entities/company_entity.dart';
import 'package:weight_finance/feature/company/domain/repositories/company_repository.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/managers/financial_data_manager.dart';

class CompanyRepositoryImpl implements ICompanyRepository {
  final ICompanyApi companyApi;
  final FinancialDataManager _financialDataManager = GlobalAPI.managers.financialDataManager;

  CompanyRepositoryImpl({required this.companyApi});

  @override
  Future<Either<Failure, Map<String, CompanyEntity>>> getCompanies() async {
    try {
      var cachedData = _financialDataManager.companies;
      if (cachedData.isEmpty) {
        final result = await companyApi.getCompanies();
        return result.fold(
          (failure) => Left(failure),
          (modelList) {
            final entityMap = modelList.map(
              (key, value) => MapEntry(key, value.toEntity()),
            );

            _financialDataManager.companies = entityMap;
            return Right(entityMap);
          },
        );
      } else {
        return Right(cachedData);
      }
    } catch (e) {
      return Left(Failure.unexpectedError(e.toString()));
    }
  }
}
