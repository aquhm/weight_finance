// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
// import 'package:weight_finance/feature/bank_rate/saving/presentation/bloc/saving_rate_bloc.dart';
// import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
// import 'package:weight_finance/global_api.dart';
// import 'package:weight_finance/data/assets/bank_logo_asset.dart';
//
// class SavingRatesScreen extends StatelessWidget {
//   const SavingRatesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         final bloc = GlobalAPI.di.get<SavingRateBloc>();
//         // 이전 상태가 SavingRateSelected인 경우에만 이전 상태로 복원
//         if (bloc.state is SavingRateSelected) {
//           bloc.restorePreviousState();
//         }
//         return bloc;
//       },
//       child: BlocConsumer<SavingRateBloc, SavingRateState>(
//         listener: (context, state) {
//           if (state is SavingRateSelected) {
//             final bloc = context.read<SavingRateBloc>();
//             final selectedProduct = state.selectedProduct;
//
//             // 이전 상태로 복원
//             bloc.restorePreviousState();
//
//             // 상태 복원 후 네비게이션
//             context.push('/finance_Saving_detail', extra: selectedProduct);
//           }
//         },
//         builder: (context, state) {
//           return BlocBuilder<GlobalFinancialBloc, GlobalFinancialState>(
//             builder: (context, globalState) {
//               return Scaffold(
//                 appBar: AppBar(
//                   title: Text("적금 상품"),
//                   // ... 기타 AppBar 내용
//                 ),
//                 body: _buildBody(context, globalState),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildBody(BuildContext context, GlobalFinancialState globalState) {
//     return switch (globalState) {
//       GlobalFinancialInitial() => const Center(child: Text('금융 데이터 초기화 중...')),
//       GlobalFinancialLoading() when globalState.isLoading(FinancialProductType.saving) => const Center(child: CircularProgressIndicator()),
//       GlobalFinancialLoaded(data: var data) => _buildLoadedState(context, data),
//       GlobalFinancialError(:var message) => Center(child: Text('Error: $message')),
//       _ => const Center(child: Text('알 수 없는 상태')),
//     };
//   }
//
//   Widget _buildLoadedState(BuildContext context, Map<FinancialProductType, dynamic> data) {
//     if (!data.containsKey(FinancialProductType.saving)) {
//       return const Center(child: Text('적금 상품 데이터가 없습니다.'));
//     }
//
//     return BlocBuilder<SavingRateBloc, SavingRateState>(
//       builder: (context, SavingState) => switch (SavingState) {
//         SavingRateInitial() => _handleInitialState(context, data[FinancialProductType.saving]),
//         SavingRateLoading() => const Center(child: CircularProgressIndicator()),
//         SavingRateLoaded(:var SavingProducts) => SavingRatesView(products: SavingProducts),
//         SavingRateError(:var message) => Center(child: Text('Error: $message')),
//         _ => const Center(child: Text('알 수 없는 적금 상태')),
//       },
//     );
//   }
//
//   Widget _handleInitialState(BuildContext context, dynamic SavingData) {
//     if (SavingData is List<SavingProductEntity>) {
//       context.read<SavingRateBloc>().add(InitializeSavingRateEvent(SavingData));
//       return const Center(child: CircularProgressIndicator());
//     } else {
//       return const Center(child: Text('잘못된 적금 데이터 형식'));
//     }
//   }
//
//   Widget _buildSearchBottomSheet(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             autofocus: true,
//             decoration: InputDecoration(
//               hintText: '은행명 또는 상품명을 입력하세요',
//               suffixIcon: Icon(Icons.search),
//             ),
//             onChanged: (value) {
//               context.read<SavingRateBloc>().add(SearchSavingRatesEvent(value));
//             },
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 child: Text('검색'),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 child: Text('취소'),
//                 onPressed: () {
//                   context.read<SavingRateBloc>().add(SearchSavingRatesEvent(""));
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
//
// class SavingRatesView extends StatefulWidget {
//   final List<SavingProductEntity> products;
//
//   const SavingRatesView({Key? key, required this.products}) : super(key: key);
//
//   @override
//   _SavingRatesViewState createState() => _SavingRatesViewState();
// }
//
// class _SavingRatesViewState extends State<SavingRatesView> {
//   final BankLogoAssets bankLogoAssets = GlobalAPI.managers.assetsManager.bankLogoAssets;
//   int? expandedIndex;
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//       context.read<SavingRateBloc>().add(LoadMoreSavingRatesEvent());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildList(widget.products);
//   }
//
//   Widget _buildList(List<SavingProductEntity> products) {
//     return Scrollbar(
//       controller: _scrollController,
//       thumbVisibility: true,
//       child: ListView.builder(
//         controller: _scrollController,
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           return SavingProductCard(
//             product: products[index],
//             isExpanded: expandedIndex == index,
//             onTap: () {
//               setState(() {
//                 expandedIndex = (expandedIndex == index) ? null : index;
//               });
//             },
//             bankLogoAssets: bankLogoAssets,
//             onDetailTap: () {
//               context.read<SavingRateBloc>().add(SelectSavingRateEvent(products[index]));
//               //context.push('/finance_detail');
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class SavingProductCard extends StatefulWidget {
//   final SavingProductEntity product;
//   final bool isExpanded;
//   final VoidCallback onTap;
//   final BankLogoAssets bankLogoAssets;
//   final VoidCallback onDetailTap;
//
//   const SavingProductCard({
//     Key? key,
//     required this.product,
//     required this.isExpanded,
//     required this.onTap,
//     required this.bankLogoAssets,
//     required this.onDetailTap,
//   }) : super(key: key);
//
//   @override
//   _ExpandableCardState createState() => _ExpandableCardState();
// }
//
// class _ExpandableCardState extends State<SavingProductCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _heightFactor;
//   late Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//
//     _heightFactor = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 70),
//       TweenSequenceItem(tween: ConstantTween<double>(1), weight: 30),
//     ]).animate(_controller);
//
//     _fade = TweenSequence<double>([
//       TweenSequenceItem(tween: ConstantTween<double>(0), weight: 70),
//       TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 30),
//     ]).animate(_controller);
//
//     if (widget.isExpanded) {
//       _controller.value = 1.0;
//     }
//   }
//
//   @override
//   void didUpdateWidget(SavingProductCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isExpanded != oldWidget.isExpanded) {
//       if (widget.isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
// //       onTap: widget.onTap,
// //       child: Card(
// //         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Padding(
// //               padding: EdgeInsets.all(16),
// //               child: _buildBasicInfo(),
// //             ),
// //             AnimatedBuilder(
// //               animation: _controller,
// //               builder: (context, child) {
// //                 return ClipRect(
// //                   child: Align(
// //                     heightFactor: _heightFactor.value,
// //                     child: Opacity(
// //                       opacity: _fade.value,
// //                       child: child,
// //                     ),
// //                   ),
// //                 );
// //               },
// //               child: Padding(
// //                 padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     _buildWayTag(),
// //                     SizedBox(height: 8),
// //                     _buildDenyType(),
// //                     SizedBox(height: 16),
// //                     _buildDetailButton(),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
//   }
//
//   Widget _buildBasicInfo() {
//     final rate = widget.product.getRateData(12);
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   widget.bankLogoAssets.getAsset(widget.product.bankId, params: {'size': 36.0}),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       widget.product.bankName,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 widget.product.productName,
//                 style: const TextStyle(fontSize: 18, color: Colors.black87),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 16),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               '${rate?.defaultRate.toStringAsFixed(2)}%',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '최대 ${rate?.preferentialRate.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWayTag() {
//     return Wrap(
//       alignment: WrapAlignment.start,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         Text("가입방법 : ", style: TextStyle(fontSize: 16)),
//         ...widget.product.joinWays
//             .map(
//               (way) => Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.grey[300],
//                 ),
//                 child: Text(way.toDisplayString(), style: TextStyle(fontSize: 14, color: Colors.black87)),
//               ),
//             )
//             .toList(),
//       ],
//     );
//   }
//
//   Widget _buildDenyType() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text("가입제한 : ", style: TextStyle(fontSize: 16)),
//         Container(
//           alignment: Alignment.center,
//           height: 30,
//           margin: EdgeInsets.symmetric(horizontal: 6),
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.grey[300],
//           ),
//           child: Text(widget.product.joinDenyType.toDisplayString(), style: TextStyle(fontSize: 14, color: Colors.black87)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailButton() {
//     return Center(
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.lightBlue,
//           padding: EdgeInsets.all(4),
//           minimumSize: Size(160, 36),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: widget.onDetailTap,
//         child: Text("상세보기", style: TextStyle(fontSize: 16, color: Colors.indigo, fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
// }

import 'package:weight_finance/feature/bank_rate/common/widget/financial_product_screen.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
import 'package:weight_finance/feature/bank_rate/saving/presentation/bloc/saving_rate_bloc.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';

class SavingRatesScreen extends FinancialProductScreen<SavingProductEntity, SavingRateBloc> {
  SavingRatesScreen()
      : super(
          title: "적금 상품",
          productType: FinancialProductType.saving,
          detailRoute: '/finance_saving_detail',
        );
}
