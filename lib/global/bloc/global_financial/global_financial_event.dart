part of 'global_financial_bloc.dart';

enum FinancialProductType {
  deposit,
  company,
  saving,
}

sealed class GlobalFinancialEvent {
  const GlobalFinancialEvent();
}

class LoadAllFinancialData extends GlobalFinancialEvent {}

class LoadFinancialData extends GlobalFinancialEvent {
  final FinancialProductType productType;

  const LoadFinancialData(this.productType);

  @override
  List<Object> get props => [productType];
}

class RefreshFinancialData extends GlobalFinancialEvent {
  final FinancialProductType productType;

  const RefreshFinancialData(this.productType);

  @override
  List<Object> get props => [productType];
}
