import 'dart:io';

import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
import 'package:weight_finance/feature/company/domain/entities/company_entity.dart';
import 'package:weight_finance/feature/exchange/domain/entities/exchange_rate_entity.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
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
  List<DepositProductEntity>? _depositProducts;
  List<SavingProductEntity>? _savingProducts;
  List<ExchangeRateEntity>? _exchangeRates;
  CommodityPricesEntity? _commodityPrice;
  Map<String, CompanyEntity> _companies = {};

  @override
  void init() {}

  @override
  void clear() {
    _depositProducts?.clear();
    _savingProducts?.clear();
    _companies?.clear();
    _exchangeRates?.clear();
    _commodityPrice = null;
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

  CommodityPricesEntity get commodityPrices => _commodityPrice ??= CommodityPricesEntity(metals: {});

  set commodityPrices(CommodityPricesEntity value) {
    _commodityPrice = value;
  }
}
