part of 'deposit_rate_bloc.dart';

sealed class DepositRateState extends FinancialProductState {}

class DepositRateInitial extends FinancialProductInitial implements DepositRateState {}

class DepositRateLoading extends FinancialProductLoading implements DepositRateState {}

class DepositRateLoaded extends FinancialProductLoaded implements DepositRateState {
  DepositRateLoaded({required List<DepositProductEntity> depositProducts, super.isSearchMode}) : super(products: depositProducts);
}

class DepositRateError extends FinancialProductError implements DepositRateState {
  DepositRateError(super.message);
}

class DepositRateSelected extends FinancialProductSelected implements DepositRateState {
  DepositRateSelected(DepositProductEntity super.selectedProduct);
}
