part of 'financial_product_bloc.dart';

@immutable
abstract class FinancialProductState {}

class FinancialProductInitial extends FinancialProductState {}

class FinancialProductLoading extends FinancialProductState {}

class FinancialProductLoaded extends FinancialProductState {
  final List<FinancialProduct> products;
  final bool isSearchMode;

  FinancialProductLoaded({required this.products, this.isSearchMode = false});
}

class FinancialProductSearched extends FinancialProductState {
  final List<FinancialProduct> products;

  FinancialProductSearched({required this.products});
}

class FinancialProductError extends FinancialProductState {
  final String message;

  FinancialProductError(this.message);
}

class FinancialProductSelected extends FinancialProductState {
  final FinancialProduct selectedProduct;

  FinancialProductSelected(this.selectedProduct);
}
