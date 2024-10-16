// part of 'saving_rate_bloc.dart';
//
// @immutable
// sealed class SavingRateEvent {}
//
// class InitializeSavingRateEvent extends SavingRateEvent {
//   final List<SavingProductEntity> products;
//
//   InitializeSavingRateEvent(this.products);
// }
//
// class LoadMoreSavingRatesEvent extends SavingRateEvent {}
//
// class SearchSavingRatesEvent extends SavingRateEvent {
//   final String query;
//
//   SearchSavingRatesEvent(this.query);
// }
//
// class SelectSavingRateEvent extends SavingRateEvent {
//   final SavingProductEntity selectedProduct;
//
//   SelectSavingRateEvent(this.selectedProduct);
// }
//
// class RestorePreviousStateEvent extends SavingRateEvent {}

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
