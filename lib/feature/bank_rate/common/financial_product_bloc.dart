import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';

part 'financial_product_event.dart';
part 'financial_product_state.dart';

abstract class FinancialProductBloc<T extends FinancialProduct> extends Bloc<FinancialProductEvent, FinancialProductState> {
  final GlobalFinancialBloc globalFinancialBloc;
  List<T> _allProducts = [];
  List<T> _displayedProducts = [];
  List<T> _searchedProducts = [];

  FinancialProductState? _previousState;
  int _currentPage = 1;
  static const int _pageSize = 20;
  bool _isSearchMode = false;

  FinancialProductBloc({required this.globalFinancialBloc}) : super(FinancialProductInitial()) {
    on<InitializeProductEvent>(_onInitializeProduct);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<SelectProductEvent>(_onSelectProduct);
    on<RestorePreviousStateEvent>(_onRestorePreviousState);
  }

  void _onInitializeProduct(
    InitializeProductEvent event,
    Emitter<FinancialProductState> emit,
  ) {
    _previousState = state;
    _allProducts = event.products.cast<T>();
    _displayedProducts = _isSearchMode ? _searchedProducts.take(_pageSize).toList() : _allProducts.take(_pageSize).toList();
    emit(FinancialProductLoaded(products: _displayedProducts, isSearchMode: _isSearchMode));
  }

  void _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<FinancialProductState> emit,
  ) {
    _previousState = state;
    _currentPage++;

    var products = _isSearchMode ? _searchedProducts : _allProducts;

    final nextPageProducts = products.skip(_currentPage * _pageSize).take(_pageSize).toList();

    _displayedProducts.addAll(nextPageProducts);

    emit(FinancialProductLoaded(products: _displayedProducts, isSearchMode: _isSearchMode));
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<FinancialProductState> emit,
  ) {
    _previousState = state;
    final searchQuery = event.query.toLowerCase();

    _searchedProducts = _allProducts
        .where((product) => product.bankName.toLowerCase().contains(searchQuery) || product.productName.toLowerCase().contains(searchQuery))
        .toList();

    _isSearchMode = searchQuery.isNotEmpty && _searchedProducts.isNotEmpty;
    _displayedProducts = _searchedProducts;

    emit(FinancialProductLoaded(products: _displayedProducts, isSearchMode: _isSearchMode));
  }

  void _onSelectProduct(
    SelectProductEvent event,
    Emitter<FinancialProductState> emit,
  ) {
    _previousState = state;
    emit(FinancialProductSelected(event.selectedProduct));
  }

  void _onRestorePreviousState(
    RestorePreviousStateEvent event,
    Emitter<FinancialProductState> emit,
  ) {
    if (_previousState != null) {
      emit(_previousState!);
      _previousState = null;
    }
  }

  void restorePreviousState() {
    add(RestorePreviousStateEvent());
  }
}
