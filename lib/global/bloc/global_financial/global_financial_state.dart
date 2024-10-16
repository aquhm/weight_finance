part of 'global_financial_bloc.dart';

sealed class GlobalFinancialState extends Equatable {
  final Map<FinancialProductType, bool> loadingStatus;

  const GlobalFinancialState({
    required this.loadingStatus,
  });

  @override
  List<Object> get props => [loadingStatus];

  bool isLoading(FinancialProductType type) => loadingStatus[type] ?? false;
  bool get isAnyLoading => loadingStatus.values.any((status) => status);

  GlobalFinancialState copyWith({
    FinancialProductType? type,
    bool? isLoading,
  }) {
    final newLoadingStatus = Map<FinancialProductType, bool>.from(loadingStatus);
    if (type != null && isLoading != null) {
      newLoadingStatus[type] = isLoading;
    }
    return GlobalFinancialLoading(loadingStatus: newLoadingStatus);
  }
}

class GlobalFinancialInitial extends GlobalFinancialState {
  GlobalFinancialInitial() : super(loadingStatus: {});
}

class GlobalFinancialLoading extends GlobalFinancialState {
  const GlobalFinancialLoading({required super.loadingStatus});
}

class GlobalFinancialLoaded extends GlobalFinancialState {
  final Map<FinancialProductType, dynamic> data;

  const GlobalFinancialLoaded({
    required this.data,
    required super.loadingStatus,
  });

  @override
  List<Object> get props => [data, loadingStatus];

  T? getData<T>(FinancialProductType type) => data[type] as T?;

  @override
  GlobalFinancialLoaded copyWith({
    FinancialProductType? type,
    bool? isLoading,
    Map<FinancialProductType, dynamic>? data,
  }) {
    final newLoadingStatus = Map<FinancialProductType, bool>.from(loadingStatus);
    if (type != null && isLoading != null) {
      newLoadingStatus[type] = isLoading;
    }
    return GlobalFinancialLoaded(
      data: data ?? this.data,
      loadingStatus: newLoadingStatus,
    );
  }
}

class GlobalFinancialError extends GlobalFinancialState {
  final FinancialProductType productType;
  final String message;

  const GlobalFinancialError({
    required this.productType,
    required this.message,
    required super.loadingStatus,
  });

  @override
  List<Object> get props => [productType, message, loadingStatus];
}
