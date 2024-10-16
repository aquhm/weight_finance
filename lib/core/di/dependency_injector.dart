import 'package:get_it/get_it.dart';
import 'package:weight_finance/core/network/dio_client.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/data_sources/remote/abstract_financial_deposit_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/data_sources/remote/financial_deposit_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/repositories/financial_deposit_repository.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/repositories/financial_repository.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/data_sources/remote/abstract_financial_saving_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/data_sources/remote/financial_saving_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/repositories/financial_saving_repository.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/use_cases/get_financial_saving_products.dart';
import 'package:weight_finance/feature/bank_rate/saving/presentation/bloc/saving_rate_bloc.dart';
import 'package:weight_finance/feature/company/data/data_sources/remote/abstract_company_api.dart';
import 'package:weight_finance/feature/company/data/data_sources/remote/company_api.dart';
import 'package:weight_finance/feature/company/data/repositories/company_repository.dart';
import 'package:weight_finance/feature/company/domain/repositories/company_repository.dart';
import 'package:weight_finance/feature/company/domain/use_cases/get_companies.dart';
import 'package:weight_finance/feature/exchange/data/data_sources/remote/abstract_exchange_rate_api.dart';
import 'package:weight_finance/feature/exchange/data/data_sources/remote/exchange_rate_api.dart';
import 'package:weight_finance/feature/exchange/data/repositories/exchange_rate_repository_Impl.dart';
import 'package:weight_finance/feature/exchange/domain/repositories/abstract_exchange_rate_repository.dart';
import 'package:weight_finance/feature/exchange/domain/use_cases/exchange_rate_usecase.dart';
import 'package:weight_finance/feature/exchange/presentation/bloc/exchange_rate_bloc.dart';
import 'package:weight_finance/feature/theme/theme_bloc.dart';

import 'package:weight_finance/feature/bank_rate/deposit/domain/use_cases/get_financial_deposit_products.dart';
import 'package:weight_finance/feature/bank_rate/deposit/presentation/bloc/deposit_rate_bloc.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
import 'package:weight_finance/global_api.dart';

class DependencyInjector {
  final GetIt _getIt = GetIt.instance;

  void init() {
    // DioClient service
    _getIt.registerLazySingleton(() => DioClient());

    // ---------------------------------------------------------------------------
    // DATA Layer
    // ---------------------------------------------------------------------------

    // Data sources
    _getIt
      ..registerLazySingleton<ICompanyApi>(() => CompanyApiImpl(dioClient: _getIt()))
      ..registerLazySingleton<IFinancialDepositRateApi>(() => FinancialDepositRateImpl(dioClient: _getIt()))
      ..registerLazySingleton<IFinancialSavingRateApi>(() => FinancialSavingRateImpl(dioClient: _getIt()))
      ..registerLazySingleton<IExchangeRateApi>(() => ExchangeRateApiImpl(dioClient: _getIt()));

    // Repositories
    _getIt
      ..registerLazySingleton<ICompanyRepository>(() => CompanyRepositoryImpl(companyApi: _getIt()))
      ..registerLazySingleton<IFinancialRepository>(() => FinancialDepositRepositoryImpl(financialDepositRateApi: _getIt()), instanceName: 'deposit')
      ..registerLazySingleton<IFinancialRepository>(() => FinancialSavingRepositoryImpl(financialSavingRateApi: _getIt()), instanceName: 'saving')
      ..registerLazySingleton<IExchangeRateRepository>(() => ExchangeRateRepositoryImpl(exchangeRateApi: _getIt()));

    // ---------------------------------------------------------------------------
    // DOMAIN Layer
    // ---------------------------------------------------------------------------

    // Use cases
    _getIt
      ..registerLazySingleton<GetCompaniesUseCase>(() => GetCompaniesUseCase(repository: _getIt()))
      ..registerLazySingleton<GetFinancialDepositProductsUseCase>(
          () => GetFinancialDepositProductsUseCase(repository: _getIt(instanceName: 'deposit')))
      ..registerLazySingleton<GetFinancialSavingProductsUseCase>(() => GetFinancialSavingProductsUseCase(repository: _getIt(instanceName: 'saving')))
      ..registerLazySingleton<ExchangeRateUseCase>(() => ExchangeRateUseCase(repository: _getIt()));

    // ---------------------------------------------------------------------------
    // PRESENTATION Layer
    // ---------------------------------------------------------------------------

    // Bloc

    // GlobalFinancialBloc
    GlobalAPI.logger.d("==========> GlobalFinancialBloc 생성자 DependencyInjector");
    _getIt.registerLazySingleton<GlobalFinancialBloc>(() => GlobalFinancialBloc(
          useCases: {
            FinancialProductType.deposit: _getIt<GetFinancialDepositProductsUseCase>(),
            FinancialProductType.saving: _getIt<GetFinancialSavingProductsUseCase>(),
            FinancialProductType.company: _getIt<GetCompaniesUseCase>(),
          },
        ));

    _getIt
      ..registerFactory(() => ExchangeRateBloc(exchangeRateUseCase: _getIt()))
      ..registerFactory(() => DepositRateBloc(globalFinancialBloc: _getIt()))
      ..registerFactory(() => SavingRateBloc(globalFinancialBloc: _getIt()));

    // Repositories

    _getIt.registerFactory(() => ThemeBloc());
  }

  void prepare() {
    var globalBloc = get<GlobalFinancialBloc>();
    globalBloc
      ..add(const LoadFinancialData(FinancialProductType.company))
      ..add(const LoadFinancialData(FinancialProductType.deposit))
      ..add(const LoadFinancialData(FinancialProductType.saving));
  }

  T get<T extends Object>() => _getIt<T>();
}
