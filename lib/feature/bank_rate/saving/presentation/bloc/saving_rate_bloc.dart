// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
// import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
//
// part 'saving_rate_event.dart';
// part 'saving_rate_state.dart';
//
// class SavingRateBloc extends Bloc<SavingRateEvent, SavingRateState> {
//   final GlobalFinancialBloc globalSavingBloc;
//   List<SavingProductEntity> _allProducts = [];
//   List<SavingProductEntity> _displayedProducts = [];
//
//   SavingRateState? _previousState;
//   int _currentPage = 1;
//   static const int _pageSize = 20;
//
//   SavingRateBloc({required this.globalSavingBloc}) : super(SavingRateInitial()) {
//     on<InitializeSavingRateEvent>(_onInitializeSavingRate);
//     on<LoadMoreSavingRatesEvent>(_onLoadMoreSavingRates);
//     on<SearchSavingRatesEvent>(_onSearchSavingRates);
//     on<SelectSavingRateEvent>(_onSelectSavingRate);
//     on<RestorePreviousStateEvent>(_onRestorePreviousState);
//   }
//
//   void _onInitializeSavingRate(
//     InitializeSavingRateEvent event,
//     Emitter<SavingRateState> emit,
//   ) {
//     _previousState = state;
//
//     _allProducts = event.products;
//     _displayedProducts = _allProducts.take(_pageSize).toList();
//     emit(SavingRateLoaded(_displayedProducts));
//   }
//
//   void _onLoadMoreSavingRates(
//     LoadMoreSavingRatesEvent event,
//     Emitter<SavingRateState> emit,
//   ) {
//     _previousState = state;
//     _currentPage++;
//     final nextPageProducts = _allProducts.skip(_currentPage * _pageSize).take(_pageSize).toList();
//     _displayedProducts.addAll(nextPageProducts);
//     emit(SavingRateLoaded(_displayedProducts));
//   }
//
//   void _onSearchSavingRates(
//     SearchSavingRatesEvent event,
//     Emitter<SavingRateState> emit,
//   ) {
//     _previousState = state;
//     final searchQuery = event.query.toLowerCase();
//     _displayedProducts = _allProducts
//         .where((product) => product.bankName.toLowerCase().contains(searchQuery) || product.productName.toLowerCase().contains(searchQuery))
//         .toList();
//     emit(SavingRateLoaded(_displayedProducts));
//   }
//
//   void _onSelectSavingRate(
//     SelectSavingRateEvent event,
//     Emitter<SavingRateState> emit,
//   ) {
//     _previousState = state;
//     emit(SavingRateSelected(event.selectedProduct));
//   }
//
//   void _onRestorePreviousState(
//     RestorePreviousStateEvent event,
//     Emitter<SavingRateState> emit,
//   ) {
//     if (_previousState != null) {
//       emit(_previousState!);
//       _previousState = null; // 이전 상태를 사용한 후 초기화
//     }
//   }
//
//   // 이전 상태로 돌아가는 편의 메서드
//   void restorePreviousState() {
//     add(RestorePreviousStateEvent());
//   }
// }

import 'package:weight_finance/feature/bank_rate/common/financial_product_bloc.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';

part 'saving_rate_event.dart';
part 'saving_rate_state.dart';

class SavingRateBloc extends FinancialProductBloc<SavingProductEntity> {
  SavingRateBloc({required super.globalFinancialBloc});
}
