// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:weight_finance/core/usecase/usecase.dart';
// import 'package:weight_finance/feature/bank_rate/domain/entities/deposit_entity.dart';
// import 'package:weight_finance/feature/bank_rate/domain/use_cases/get_financial_products.dart';
//
// part 'global_deposit_event.dart';
// part 'global_deposit_state.dart';
//
// class GlobalDepositBloc extends Bloc<GlobalDepositEvent, GlobalDepositState> {
//   final GetFinancialProductsUseCase getFinancialProducts;
//   List<DepositProductEntity>? _cachedProducts;
//   bool _isLoading = false;
//
//   GlobalDepositBloc({required this.getFinancialProducts}) : super(GlobalDepositInitial()) {
//     on<LoadGlobalDepositProducts>(_onLoadGlobalDepositProducts);
//     on<RefreshGlobalDepositProducts>(_onRefreshGlobalDepositProducts);
//   }
//
//   Future<void> _onLoadGlobalDepositProducts(
//     LoadGlobalDepositProducts event,
//     Emitter<GlobalDepositState> emit,
//   ) async {
//     if (_cachedProducts != null) {
//       emit(GlobalDepositLoaded(_cachedProducts!));
//       return;
//     }
//
//     if (_isLoading) {
//       emit(GlobalDepositLoading());
//       return;
//     }
//
//     _isLoading = true;
//     emit(GlobalDepositLoading());
//
//     final result = await getFinancialProducts(NoParams());
//
//     result.fold(
//       (failure) => emit(GlobalDepositError(failure.toString())),
//       (products) {
//         _isLoading = false;
//         _cachedProducts = products.whereType<DepositProductEntity>().toList();
//         emit(GlobalDepositLoaded(_cachedProducts!));
//       },
//     );
//   }
//
//   Future<void> _onRefreshGlobalDepositProducts(
//     RefreshGlobalDepositProducts event,
//     Emitter<GlobalDepositState> emit,
//   ) async {
//     if (_isLoading) return;
//
//     _isLoading = true;
//     emit(GlobalDepositLoading());
//
//     final result = await getFinancialProducts(NoParams());
//
//     _isLoading = false;
//     result.fold(
//       (failure) => emit(GlobalDepositError(failure.toString())),
//       (products) {
//         _cachedProducts = products.whereType<DepositProductEntity>().toList();
//         emit(GlobalDepositLoaded(_cachedProducts!));
//       },
//     );
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/global_api.dart';

part 'global_financial_event.dart';
part 'global_financial_state.dart';

class GlobalFinancialBloc extends Bloc<GlobalFinancialEvent, GlobalFinancialState> {
  final Map<FinancialProductType, UseCase> _useCases;
  final Map<FinancialProductType, dynamic> _cachedData = {};

  GlobalFinancialBloc({required Map<FinancialProductType, UseCase> useCases})
      : _useCases = useCases,
        super(GlobalFinancialInitial()) {
    GlobalAPI.logger.d("==========> GlobalFinancialBloc 생성자");
    on<LoadAllFinancialData>(_onLoadAllFinancialData);
    on<LoadFinancialData>(_onLoadFinancialData);
    on<RefreshFinancialData>(_onRefreshFinancialData);
  }

  Future<void> _onLoadAllFinancialData(
    LoadAllFinancialData event,
    Emitter<GlobalFinancialState> emit,
  ) async {
    for (var type in _useCases.keys) {
      emit(state.copyWith(type: type, isLoading: true));
    }

    await Future.wait(
      _useCases.keys.map((type) => _loadData(type, emit)),
    );
  }

  Future<void> _onLoadFinancialData(
    LoadFinancialData event,
    Emitter<GlobalFinancialState> emit,
  ) async {
    await _loadData(event.productType, emit);
  }

  Future<void> _loadData(FinancialProductType type, Emitter<GlobalFinancialState> emit) async {
    emit(state.copyWith(type: type, isLoading: true));

    final result = await _useCases[type]!(NoParams());

    result.fold(
      (failure) => emit(GlobalFinancialError(
        productType: type,
        message: failure.toString(),
        loadingStatus: state.loadingStatus,
      )),
      (data) {
        _cachedData[type] = data;
        if (state is GlobalFinancialLoaded) {
          emit((state as GlobalFinancialLoaded).copyWith(
            type: type,
            isLoading: false,
            data: Map.from(_cachedData),
          ));
        } else {
          emit(GlobalFinancialLoaded(
            data: Map.from(_cachedData),
            loadingStatus: Map.from(state.loadingStatus)..update(type, (_) => false, ifAbsent: () => false),
          ));
        }
      },
    );
  }

  Future<void> _onRefreshFinancialData(
    RefreshFinancialData event,
    Emitter<GlobalFinancialState> emit,
  ) async {
    await _loadData(event.productType, emit);
  }
}
