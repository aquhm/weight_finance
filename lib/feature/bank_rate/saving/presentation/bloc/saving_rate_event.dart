part of 'saving_rate_bloc.dart';

sealed class SavingRateEvent extends FinancialProductEvent {}

class InitializeSavingRateEvent extends InitializeProductEvent {
  InitializeSavingRateEvent(List<SavingProductEntity> products) : super(products);
}

class LoadMoreSavingRatesEvent extends LoadMoreProductsEvent {}

class SearchSavingRatesEvent extends SearchProductsEvent {
  SearchSavingRatesEvent(String query) : super(query);
}

class SelectSavingRateEvent extends SelectProductEvent {
  SelectSavingRateEvent(SavingProductEntity selectedProduct) : super(selectedProduct);
}
