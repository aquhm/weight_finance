import 'dart:io';

import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
import 'package:weight_finance/feature/company/domain/entities/company_entity.dart';
import 'package:weight_finance/feature/exchange/domain/entities/exchange_rate_entity.dart';
import 'package:weight_finance/managers/base_manager.dart';

enum FinancialProductType {
  company,
  deposit,
  saving,
  annuity,
  creditLoan,
  mortgageLoan,
  jeonseeLoan,
}

class FinancialDataManager implements IManager {
  // final List<String> _fileNames = [
  //   'company.csv', //회사 정보
  //   'deposit.csv', //예금
  //   'saving.csv', //적금
  //   'annuity.csv', //연금저축
  //   'credit.csv', //개인신용대출
  //   'mortgage.csv', //주택담보대출
  //   'rent.csv', //전세자금대출
  // ];

  //List<String> get fileNames => _fileNames;

  //late FinancialDataService _financialDataService;
  //final Map<String, FinancialData> _cachedData = {};

  //Map<String, FinancialData> get cachedData => _cachedData;

  // DepositData get depositData => _cachedData['deposit.csv'] as DepositData;
  // SavingData get savingData => _cachedData['saving.csv'] as SavingData;
  // CompanyData get companyData => _cachedData['company.csv'] as CompanyData;

  List<DepositProductEntity>? _depositProducts;
  List<SavingProductEntity>? _savingProducts;
  List<ExchangeRateEntity>? _exchangeRates;
  Map<String, CompanyEntity> _companies = {};

  @override
  void init() {
    //_financialDataService = GlobalAPI.services.financialDataService;
    //getData();
  }

  @override
  void clear() {
    _depositProducts?.clear();
    _savingProducts?.clear();
    _companies?.clear();
    _exchangeRates?.clear();
    //_cachedData.clear();
  }

  @override
  void dispose() {
    clear();
  }

  List<DepositProductEntity> get depositProducts => _depositProducts ?? [];

  set depositProducts(List<DepositProductEntity> value) {
    _depositProducts = value;
  }

  List<SavingProductEntity> get savingProducts => _savingProducts ?? [];

  set savingProducts(List<SavingProductEntity> value) {
    _savingProducts = value;
  }

  Map<String, CompanyEntity> get companies => _companies ?? {};

  set companies(Map<String, CompanyEntity> value) {
    _companies = value;
  }

  CompanyEntity? getCompanyEntity(String bankId) {
    return _companies[bankId];
  }

  List<ExchangeRateEntity> get exchangeRates => _exchangeRates ?? [];

  set exchangeRates(List<ExchangeRateEntity> value) {
    _exchangeRates = value;
  }

  ExchangeRateEntity? exchangeRate(String code) {
    var result = _exchangeRates?.firstWhere((t) => t.currencyCode == code);
    return result;
  }

  // Future<Map<String, FinancialData>> getData() async {
  //   if (_cachedData.isEmpty) {
  //     //await refreshData();
  //   }
  //   return _cachedData;
  // }
  //
  // Future<void> refreshData() async {
  //   var fetchResult = await _financialDataService.fetchData(_fileNames);
  //   if (fetchResult.isNotEmpty) {
  //     _saveToFilesAsync(fetchResult);
  //
  //     for (var result in fetchResult) {
  //       try {
  //         var financialData = _convertFromCsv(result.item1, result.item2);
  //         _cachedData[result.item1] = financialData;
  //
  //         GlobalAPI.logger.d('Loaded data for $result.item1');
  //       } catch (e) {
  //         GlobalAPI.logger.e('Error loading data for $result.item1: $e');
  //       }
  //     }
  //   } else {
  //     GlobalAPI.logger.d('Failed to fetch data from the server');
  //   }
  // }
  //
  // FinancialData _convertFromCsv(String fileName, String csvContent) {
  //   return switch (fileName) {
  //     // 'company.csv' => CompanyData.convertFromCsv(csvContent),
  //     // 'annuity.csv' => AnnuityData.convertFromCsv(csvContent),
  //     // 'credit.csv' => CreditData.convertFromCsv(csvContent),
  //     // 'deposit.csv' => DepositData.convertFromCsv(csvContent),
  //     // 'mortgage.csv' => MortgageData.convertFromCsv(csvContent),
  //     // 'rent.csv' => RentData.convertFromCsv(csvContent),
  //     // 'saving.csv' => SavingData.convertFromCsv(csvContent),
  //     _ => throw Exception('Unsupported file type: $fileName'),
  //   };
  // }
  //
  // CompanyInfo? getComanyInfo(String bankId) {
  //   return companyData.companyInfos[bankId];
  // }
  //
  // FinancialData? getDataForFile(String fileName) {
  //   return _cachedData[fileName];
  // }
  //
  // Future<void> _saveToFilesAsync(List<Tuple2<String, String>> fileInfos) async {
  //   for (var value in fileInfos) {
  //     await _saveFile(value.item1, value.item2);
  //   }
  // }
  //
  // Future<File> _getLocalFile(String fileName) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return File('${directory.path}/$fileName');
  // }
  //
  // Future<void> _saveFile(String fileName, String fileData) async {
  //   final localFile = await _getLocalFile(fileName);
  //
  //   if (localFile != null && fileData.isNotEmpty) {
  //     localFile.writeAsString(fileData).then((_) {
  //       print('${localFile.path} saved to local storage');
  //     }).catchError((error) {
  //       print('Error saving file ${localFile.path}: $error');
  //     });
  //   }
  // }
}
