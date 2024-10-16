import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product_bloc.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
import 'package:weight_finance/global_api.dart';

class FinancialProductScreen<T extends FinancialProduct, BlocType extends FinancialProductBloc<T>> extends StatelessWidget {
  final String title;
  final FinancialProductType productType;
  final String detailRoute;

  const FinancialProductScreen({
    super.key,
    required this.title,
    required this.productType,
    required this.detailRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = GlobalAPI.di.get<BlocType>();
        if (bloc.state case FinancialProductSelected(:final selectedProduct)) {
          bloc.restorePreviousState();
          context.push(detailRoute, extra: selectedProduct);
        }
        return bloc;
      },
      child: Builder(
        builder: (context) {
          final bloc = context.read<BlocType>();
          return BlocConsumer<BlocType, FinancialProductState>(
            listener: (context, state) {
              if (state case FinancialProductSelected(:final selectedProduct)) {
                bloc.restorePreviousState();
                context.push(detailRoute, extra: selectedProduct);
              }
            },
            builder: (context, state) {
              final isSearchMode = state is FinancialProductLoaded && state.isSearchMode;
              return Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: _buildActionButton(
                        isSearchMode: isSearchMode,
                        onPressed: isSearchMode ? () => bloc.add(SearchProductsEvent("")) : () => _showSearchBottomSheet(context, bloc),
                      ),
                    ),
                  ],
                ),
                body: _buildBody(context, state),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required bool isSearchMode,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(
        isSearchMode ? Icons.close : Icons.search,
        color: Colors.grey,
      ),
      label: Text(
        isSearchMode ? '초기화' : '검색',
        style: TextStyle(color: Colors.grey),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: onPressed,
    );
  }

  void _showSearchBottomSheet(BuildContext context, BlocType bloc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _buildSearchBottomSheet(context, bloc),
    );
  }

  Widget _buildBody(BuildContext context, FinancialProductState state) {
    return BlocBuilder<GlobalFinancialBloc, GlobalFinancialState>(
      builder: (context, globalState) {
        return switch (globalState) {
          GlobalFinancialInitial() => const Center(child: Text('금융 데이터 초기화 중...')),
          GlobalFinancialLoading() when globalState.isLoading(productType) => const Center(child: CircularProgressIndicator()),
          GlobalFinancialLoaded(data: var data) => _buildProductState(context, state, data),
          GlobalFinancialError(:final message) => Center(child: Text('Error: $message')),
          _ => const Center(child: Text('알 수 없는 글로벌 상태')),
        };
      },
    );
  }

  Widget _buildProductState(BuildContext context, FinancialProductState state, Map<FinancialProductType, dynamic> data) {
    return switch (state) {
      FinancialProductInitial() => _handleInitialState(context, data[productType]),
      FinancialProductLoading() => const Center(child: CircularProgressIndicator()),
      FinancialProductLoaded(:final products, :final isSearchMode) => products.isEmpty && isSearchMode
          ? _buildNoSearchResult(context)
          : FinancialProductListView(
              products: products.cast<T>(),
              onProductSelected: (product) {
                context.read<BlocType>().add(SelectProductEvent(product));
              },
              onLoadMore: () {
                context.read<BlocType>().add(LoadMoreProductsEvent());
              },
            ),
      FinancialProductError(:final message) => Center(child: Text('Error: $message')),
      FinancialProductSelected() => const Center(child: Text('상품이 선택되었습니다.')),
      _ => const Center(child: Text('알 수 없는 상태')),
    };
  }

  Widget _buildNoSearchResult(BuildContext context) {
    final bloc = context.read<BlocType>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 50, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '검색 결과가 없습니다.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '다른 검색어를 입력해보세요.',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(4),
              minimumSize: Size(160, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('상품 리스트 다시보기'),
            onPressed: () => {bloc.add(SearchProductsEvent(""))},
          ),
        ],
      ),
    );
  }

  Widget _handleInitialState(BuildContext context, dynamic productData) {
    if (productData is List<T>) {
      context.read<BlocType>().add(InitializeProductEvent(productData));
      return const Center(child: CircularProgressIndicator());
    } else {
      return const Center(child: Text('잘못된 데이터 형식'));
    }
  }

  Widget _buildSearchBottomSheet(BuildContext context, BlocType bloc) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: '은행명 또는 상품명을 입력하세요',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                bloc.add(SearchProductsEvent(value));
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('검색'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text('취소'),
                  onPressed: () {
                    bloc.add(SearchProductsEvent(""));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialProductListView extends StatefulWidget {
  final List<FinancialProduct> products;
  final Function(FinancialProduct) onProductSelected;
  final Function() onLoadMore;

  const FinancialProductListView({
    Key? key,
    required this.products,
    required this.onProductSelected,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _FinancialProductListViewState createState() => _FinancialProductListViewState();
}

class _FinancialProductListViewState extends State<FinancialProductListView> {
  final ScrollController _scrollController = ScrollController();
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return FinancialProductCard(
          isExpanded: expandedIndex == index,
          product: widget.products[index],
          onTap: () => {
            setState(() {
              expandedIndex = (expandedIndex == index) ? null : index;
            })
          },
          onDetailTap: () => {
            widget.onProductSelected(widget.products[index]),
          },
        );
      },
    );
  }
}

class FinancialProductCard extends StatefulWidget {
  final FinancialProduct product;
  final VoidCallback onTap;
  final VoidCallback onDetailTap;
  final bool isExpanded;

  const FinancialProductCard({
    Key? key,
    required this.product,
    required this.isExpanded,
    required this.onTap,
    required this.onDetailTap,
  }) : super(key: key);

  @override
  State<FinancialProductCard> createState() => _FinancialProductCardState();
}

class _FinancialProductCardState extends State<FinancialProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _heightFactor = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 70),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 30),
    ]).animate(_controller);

    _fade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 70),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 30),
    ]).animate(_controller);

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FinancialProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: _buildBasicInfo(),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    heightFactor: _heightFactor.value,
                    child: Opacity(
                      opacity: _fade.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildWayTag(),
                    SizedBox(height: 8),
                    _buildDenyType(),
                    SizedBox(height: 16),
                    _buildDetailButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    final rate = widget.product.getDefaultRateData();
    final bankLogoAssets = GlobalAPI.managers.assetsManager.bankLogoAssets;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  bankLogoAssets.getAsset(widget.product.bankId, params: {'size': 36.0}),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.product.bankName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.productName,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${rate?.defaultRate.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '최대 ${rate?.preferentialRate.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            // const SizedBox(height: 4),
            // Text(
            //   ' ${rate?.month}개월 기준',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey[600],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildWayTag() {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Text("가입방법 : ", style: TextStyle(fontSize: 16)),
        ...widget.product.joinWays
            .map(
              (way) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                ),
                child: Text(way.toDisplayString(), style: TextStyle(fontSize: 14, color: Colors.black87)),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildDenyType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("가입제한 : ", style: TextStyle(fontSize: 16)),
        Container(
          alignment: Alignment.center,
          height: 30,
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[300],
          ),
          child: Text(widget.product.joinDenyType.toDisplayString(), style: TextStyle(fontSize: 14, color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildDetailButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          padding: EdgeInsets.all(4),
          minimumSize: Size(160, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.onDetailTap,
        child: Text("상세보기", style: TextStyle(fontSize: 16, color: Colors.indigo, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final rate = widget.product.getRateData(12);
  //   final bankLogoAssets = GlobalAPI.managers.assetsManager.bankLogoAssets;
  //   return GestureDetector(
  //     onTap: widget.onTap,
  //     child: Card(
  //       child: ListTile(
  //         leading: bankLogoAssets.getAsset(widget.product.bankId, params: {'size': 40.0}),
  //         title: Text(widget.product.productName),
  //         subtitle: Text(widget.product.bankName),
  //         trailing: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text('${rate?.defaultRate.toStringAsFixed(2)}%', style: TextStyle(fontWeight: FontWeight.bold)),
  //             Text('최대 ${rate?.preferentialRate.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12)),
  //           ],
  //         ),
  //         onTap: widget.onTap,
  //       ),
  //     ),
  //   );
  // }
}
