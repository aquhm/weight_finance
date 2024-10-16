part of 'deposit_rate_bloc.dart';

abstract class DepositRateEvent extends FinancialProductEvent {}

class InitializeDepositRateEvent extends InitializeProductEvent {
  InitializeDepositRateEvent(List<DepositProductEntity> products) : super(products);
}

class LoadMoreDepositRatesEvent extends LoadMoreProductsEvent {}

class SearchDepositRatesEvent extends SearchProductsEvent {
  SearchDepositRatesEvent(String query) : super(query);
}

class SelectDepositRateEvent extends SelectProductEvent {
  SelectDepositRateEvent(DepositProductEntity selectedProduct) : super(selectedProduct);
}
