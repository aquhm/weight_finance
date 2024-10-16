// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:weight_finance/global_api.dart';
// import 'package:weight_finance/controllers/finance_detail_controller.dart';
// import 'package:weight_finance/controllers/finance_screen_controller.dart';
// import 'package:weight_finance/data/assets/bank_logo_asset.dart';
// import 'package:weight_finance/data/financialData/financial_data.dart';
// import 'package:weight_finance/managers/financial_data_manager.dart';
// import 'package:weight_finance/utils/string_helper.dart';
//
// class FinanceScreen extends StatefulWidget {
//   const FinanceScreen({super.key});
//
//   @override
//   _FinanceScreenState createState() => _FinanceScreenState();
// }
//
// class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
//   final FinanceScreenController controller = GlobalAPI.managers.controllerManager.financeScreenController;
//   final FinanceDetailController financeDetailController = GlobalAPI.managers.controllerManager.financeDetailController;
//   final BankLogoAssets bankLogoAssets = GlobalAPI.managers.assetsManager.bankLogoAssets;
//   late TabController _tabController;
//   late ScrollController _depositScrollController;
//   late ScrollController _savingScrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _depositScrollController = ScrollController();
//     _savingScrollController = ScrollController();
//     _depositScrollController.addListener(() => _onScroll(FinancialProductType.deposit));
//     _savingScrollController.addListener(() => _onScroll(FinancialProductType.saving));
//     _tabController.addListener(_handleTabChange);
//     controller.setSearchQuery("");
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _depositScrollController.dispose();
//     _savingScrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll(FinancialProductType type) {
//     final scrollController = type == FinancialProductType.deposit ? _depositScrollController : _savingScrollController;
//     if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
//       controller.loadMoreItems();
//     }
//   }
//
//   void _handleTabChange() {
//     if (_tabController.indexIsChanging) {
//       FinancialProductType newType = _tabController.index == 0 ? FinancialProductType.deposit : FinancialProductType.saving;
//       controller.changeProductType(newType);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("financial products".tr),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: "deposit_title".tr),
//             Tab(text: "saving_title".tr),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 builder: (context) => _buildSearchBottomSheet(),
//               );
//             },
//           ),
//         ],
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildList(FinancialProductType.deposit),
//           _buildList(FinancialProductType.saving),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 1,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildList(FinancialProductType type) {
//     return Obx(() {
//       var list = type == FinancialProductType.deposit ? controller.filteredDepositList : controller.filteredSavingList;
//
//       return Scrollbar(
//         controller: type == FinancialProductType.deposit ? _depositScrollController : _savingScrollController,
//         thumbVisibility: true,
//         child: ListView.builder(
//           controller: type == FinancialProductType.deposit ? _depositScrollController : _savingScrollController,
//           itemCount: list.length,
//           itemBuilder: (context, index) {
//             return _buildExpandableListItem(index, list[index]);
//           },
//         ),
//       );
//     });
//   }
//
//   Widget _buildExpandableListItem(int index, FinancialInfo info) {
//     return Obx(() {
//       bool isExpanded = controller.expandedIndex.value == index;
//       return GestureDetector(
//         onTap: () => controller.toggleExpansion(index),
//         child: TweenAnimationBuilder<double>(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.fastOutSlowIn,
//           tween: Tween<double>(begin: isExpanded ? 240 : 118, end: isExpanded ? 240 : 118),
//           builder: (context, height, child) {
//             return Container(
//               height: height,
//               child: Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildBasicInfo(info),
//                       if (height == 240)
//                         TweenAnimationBuilder<double>(
//                           duration: Duration(milliseconds: 300),
//                           tween: Tween<double>(
//                             begin: isExpanded ? 0 : 1,
//                             end: isExpanded ? 1 : 0,
//                           ),
//                           builder: (context, opacity, child) {
//                             return Opacity(
//                               opacity: isExpanded ? opacity : 1 - opacity,
//                               child: child,
//                             );
//                           },
//                           child: _buildAdditionalInfo(info),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }
//
//   // ... 기존의 _buildBasicInfo, _buildAdditionalInfo, _buildWayTag, _buildDenyType, _buildDetailButton 메서드들 ...
//
//   Widget _buildSearchBottomSheet() {
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
//               controller.setSearchQuery(value);
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
//                   controller.setSearchQuery("");
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
//
//   Widget _buildAdditionalInfo(FinancialInfo info) {
//     return Column(
//       // Expanded를 Column으로 변경
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 6),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             _buildWayTag(info),
//           ],
//         ),
//         SizedBox(height: 6),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             _buildDenyType(info),
//           ],
//         ),
//         SizedBox(height: 2),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildDetailButton(info),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBasicInfo(FinancialInfo info) {
//     final rate = info.getRateData(12);
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   bankLogoAssets.getAsset(info.bankId, params: {'size': 36.0}),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       info.bankName,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 info.productName.removeNewlines(),
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
//               '${rate?.defaultRate ?? 'N/A'}%',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${"max_title".tr} ${rate?.preferentialRate ?? 'N/A'}%',
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
//   Widget _buildWayTag(FinancialInfo info) {
//     List<Widget> buildEntry() {
//       return info.joinWays
//           .map(
//             (x) => Container(
//               alignment: Alignment(0.0, 0.0),
//               height: 30,
//               margin: EdgeInsets.symmetric(horizontal: 6),
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.grey[300],
//               ),
//               child: Text(x.toDisplayString(), style: TextStyle(fontSize: 14, color: Colors.black87)),
//             ),
//           )
//           .whereType<Widget>()
//           .toList();
//     }
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           "가입방법 : ",
//           style: TextStyle(fontSize: 16),
//         ),
//         ...buildEntry(),
//       ],
//     );
//   }
//
//   Widget _buildDenyType(FinancialInfo info) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text("가입방법 : ", style: TextStyle(fontSize: 16)),
//         Container(
//           alignment: Alignment(0.0, 0.0),
//           height: 30,
//           margin: EdgeInsets.symmetric(horizontal: 6),
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.grey[300],
//           ),
//           child: Text(info.joinDenyType.toDisplayString(), style: TextStyle(fontSize: 14, color: Colors.black87)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailButton(FinancialInfo info) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.lightBlue,
//         padding: EdgeInsets.all(4),
//         minimumSize: Size(160, 36), // 가로 크기 200, 세로 크기 40으로 설정
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       onPressed: () {
//         financeDetailController.setFinancialInfo(info);
//
//         context.push('/finance_detail');
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("상세보기", style: TextStyle(fontSize: 16, color: Colors.indigo, fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }
