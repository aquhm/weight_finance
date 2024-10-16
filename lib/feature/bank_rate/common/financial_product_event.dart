part of 'financial_product_bloc.dart';

@immutable
abstract class FinancialProductEvent {}

class InitializeProductEvent extends FinancialProductEvent {
  final List<FinancialProduct> products;

  InitializeProductEvent(this.products);
}

class LoadMoreProductsEvent extends FinancialProductEvent {}

class SearchProductsEvent extends FinancialProductEvent {
  final String query;

  SearchProductsEvent(this.query);
}

class SelectProductEvent extends FinancialProductEvent {
  final FinancialProduct selectedProduct;

  SelectProductEvent(this.selectedProduct);
}

class RestorePreviousStateEvent extends FinancialProductEvent {}
