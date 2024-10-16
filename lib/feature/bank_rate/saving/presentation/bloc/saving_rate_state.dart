part of 'saving_rate_bloc.dart';

// @immutable
// sealed class SavingRateState {}
//
// final class SavingRateInitial extends SavingRateState {}
//
// class SavingRateLoading extends SavingRateState {}
//
// class SavingRateLoaded extends SavingRateState {
//   final List<SavingProductEntity> SavingProducts;
//
//   SavingRateLoaded(this.SavingProducts);
// }
//
// class SavingRateError extends SavingRateState {
//   final String message;
//
//   SavingRateError(this.message);
// }
//
// class SavingRateSelected extends SavingRateState {
//   final SavingProductEntity selectedProduct;
//
//   SavingRateSelected(this.selectedProduct);
// }

sealed class SavingRateState extends FinancialProductState {}

class SavingRateInitial extends FinancialProductInitial implements SavingRateState {}

class SavingRateLoading extends FinancialProductLoading implements SavingRateState {}

class SavingRateLoaded extends FinancialProductLoaded implements SavingRateState {
  SavingRateLoaded({required List<SavingProductEntity> savingProducts, super.isSearchMode}) : super(products: savingProducts);
}

class SavingRateError extends FinancialProductError implements SavingRateState {
  SavingRateError(String message) : super(message);
}

class SavingRateSelected extends FinancialProductSelected implements SavingRateState {
  SavingRateSelected(SavingProductEntity selectedProduct) : super(selectedProduct);
}
