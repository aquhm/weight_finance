// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:weight_finance/controllers/finance_detail_controller.dart';
// import 'package:weight_finance/data/financialData/financial_data.dart';
// import 'package:weight_finance/global_api.dart';
// import 'package:weight_finance/data/assets/bank_logo_asset.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:weight_finance/utils/currency_formatter.dart';
//
// class FinanceDetailScreen extends StatefulWidget {
//   const FinanceDetailScreen({Key? key}) : super(key: key);
//
//   @override
//   _FinanceDetailScreenState createState() => _FinanceDetailScreenState();
// }
//
// class _FinanceDetailScreenState extends State<FinanceDetailScreen> with SingleTickerProviderStateMixin {
//   final FinanceDetailController controller = GlobalAPI.managers.controllerManager.financeDetailController;
//   final BankLogoAssets bankLogoAssets = GlobalAPI.managers.assetsManager.bankLogoAssets;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//     controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _handleTabChange() {
//     if (_tabController.indexIsChanging) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         controller.toggleInterestType();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text(controller.financialInfo.value?.productName ?? '')),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () {
//               // 공유 기능 구현
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.financialInfo.value == null) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               _buildRateInfo(),
//               _buildInterestByPeriod(),
//               Divider(thickness: 4),
//               _buildJoinMethods(),
//               _buildBankWebsite(),
//               Divider(thickness: 4),
//               _buildDetailedProductInfo(),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           bankLogoAssets.getAsset(controller.financialInfo.value?.bankId ?? '', params: {'size': 60.0}),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   controller.financialInfo.value?.bankName ?? '',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   controller.financialInfo.value?.productName ?? '',
//                   style: TextStyle(fontSize: 20, color: Colors.black87),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRateInfo() {
//     final rate = controller.financialInfo.value?.getRateData(12);
//     return Container(
//       margin: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.baseline,
//             textBaseline: TextBaseline.alphabetic,
//             children: [
//               Text("금리 정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(width: 8),
//               Text("(12개월 기준)", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//             ],
//           ),
//           SizedBox(height: 8),
//           _buildRateInfoRow("기본 금리", "${rate?.defaultRate ?? 'N/A'}%"),
//           _buildRateInfoRow("최대 금리", "${rate?.preferentialRate ?? 'N/A'}%", isHighlighted: true),
//           _buildRateInfoRow("최고 한도", _formatMaxLimit()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRateInfoRow(String label, String value, {bool isHighlighted = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(fontSize: 16)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: isHighlighted ? Colors.blue : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatMaxLimit() {
//     int? maxLimit = controller.financialInfo.value?.maximumAmount;
//     return maxLimit == null || maxLimit == 0 ? "정보없음" : CurrencyFormatter.formatKoreanWon(maxLimit);
//   }
//
//   Widget _buildInterestByPeriod() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("기간별 금리 정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(height: 16),
//           _buildInterestTypeToggle(),
//           SizedBox(height: 16),
//           _buildRateCards(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInterestTypeToggle() {
//     return Obx(() {
//       bool hasCompoundInterest = controller.financialInfo.value?.compoundRateList.isNotEmpty ?? false;
//       bool hasSimpleInterest = controller.financialInfo.value?.simpleRateList.isNotEmpty ?? false;
//
//       if (hasCompoundInterest && hasSimpleInterest) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//           ),
//           child: TabBar(
//             controller: _tabController,
//             labelColor: Colors.black,
//             indicatorColor: Colors.grey[800],
//             unselectedLabelColor: Colors.grey[600],
//             tabs: [
//               Tab(text: "단리"),
//               Tab(text: "복리"),
//             ],
//           ),
//         );
//       } else {
//         return SizedBox.shrink();
//       }
//     });
//   }
//
//   Widget _buildRateCards() {
//     return Obx(() {
//       var rateList = controller.currentRateList;
//       bool isDeposit = controller.financialInfo.value?.financialType == FinancialType.deposit;
//
//       var index = isDeposit ? 1 : 2;
//       // 정렬
//       rateList.sort((a, b) => int.parse(a.key.substring(index)).compareTo(int.parse(b.key.substring(index))));
//
//       if (isDeposit) {
//         return _buildRateCardGrid(rateList, "");
//       } else {
//         var regularRates = rateList.where((entry) => entry.key[1] == 'S').toList();
//         var freeRates = rateList.where((entry) => entry.key[1] == 'F').toList();
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (regularRates.isNotEmpty) ...[
//               Text("정액적립", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               _buildRateCardGrid(regularRates, ""),
//               SizedBox(height: 16),
//             ],
//             if (freeRates.isNotEmpty) ...[
//               Text("자유적립", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               _buildRateCardGrid(freeRates, ""),
//             ],
//           ],
//         );
//       }
//     });
//   }
//
//   Widget _buildRateCardGrid(List<MapEntry<String, FinancialRate>> rates, String title) {
//     // 먼저 rates를 month에 따라 오름차순으로 정렬합니다.
//     rates.sort((a, b) => a.value.month.compareTo(b.value.month));
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (title.isNotEmpty) Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             childAspectRatio: 1.5,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: rates.length,
//           itemBuilder: (context, index) {
//             var entry = rates[index];
//             FinancialRate rate = entry.value;
//             return _buildRateCard(rate);
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRateCard(FinancialRate rate) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "${rate.month}개월",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 4),
//             Text(
//               "${rate.defaultRate}%",
//               style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInterestTable() {
//     return Obx(() {
//       var rateList = controller.currentRateList;
//       bool isDeposit = controller.financialInfo.value?.financialType == FinancialType.deposit;
//
//       if (isDeposit) {
//         return _buildDepositRateTable(rateList);
//       } else {
//         return _buildSavingsRateTable(rateList);
//       }
//     });
//   }
//
//   Widget _buildDepositRateTable(List<MapEntry<String, FinancialRate>> rateList) {
//     return _buildRateTable(rateList, "예금 금리");
//   }
//
//   Widget _buildSavingsRateTable(List<MapEntry<String, FinancialRate>> rateList) {
//     var regularRates = rateList.where((entry) => entry.key[1] == 'S').toList();
//     var freeRates = rateList.where((entry) => entry.key[1] == 'F').toList();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (regularRates.isNotEmpty) ...[
//           Text("정액적립", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           _buildRateTable(regularRates, ""),
//           SizedBox(height: 16),
//         ],
//         if (freeRates.isNotEmpty) ...[
//           Text("자유적립", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           _buildRateTable(freeRates, ""),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildRateTable(List<MapEntry<String, FinancialRate>> rates, String title) {
//     rates.sort((a, b) => int.parse(a.key.substring(1)).compareTo(int.parse(b.key.substring(2))));
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (title.isNotEmpty) Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         Table(
//           border: TableBorder.all(color: Colors.grey[300]!),
//           children: [
//             TableRow(
//               decoration: BoxDecoration(color: Colors.grey[200]),
//               children: [
//                 _buildTableCell('기간', isHeader: true),
//                 _buildTableCell('금리', isHeader: true),
//               ],
//             ),
//             ...rates.map((entry) {
//               String period = entry.key.substring(2);
//               FinancialRate rate = entry.value;
//               return TableRow(
//                 children: [
//                   _buildTableCell('$period개월'),
//                   _buildTableCell('${rate.defaultRate}%'),
//                 ],
//               );
//             }).toList(),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTableCell(String text, {bool isHeader = false}) {
//     return TableCell(
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildJoinMethods() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("가입 방법", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: controller.financialInfo.value?.joinWays
//                     .map((way) => Chip(
//                           label: Text(way.toDisplayString()),
//                           backgroundColor: Colors.grey[300],
//                         ))
//                     .toList() ??
//                 [],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBankWebsite() {
//     var companyInfo = GlobalAPI.managers.financialDataManager.getComanyInfo(controller.financialInfo.value?.bankId ?? '');
//     return ListTile(
//       title: Text("은행 홈페이지", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//       subtitle: Text(companyInfo?.hompUrl ?? "정보 없음", style: TextStyle(fontSize: 16)),
//       trailing: Icon(Icons.open_in_new),
//       onTap: () async {
//         if (companyInfo?.hompUrl != null) {
//           var uri = Uri.parse(companyInfo!.hompUrl);
//           if (await canLaunchUrl(uri)) {
//             await launchUrl(uri);
//           }
//         }
//       },
//     );
//   }
//
//   Widget _buildDetailedProductInfo() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("상세 상품 정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(height: 16),
//           _buildInfoSection("만기 후 이자율", controller.financialInfo.value?.maturityRate ?? "정보 없음"),
//           _buildInfoSection("우대조건", controller.financialInfo.value?.preferentialTreatment ?? "정보 없음"),
//           _buildInfoSection("기타 유의사항", controller.financialInfo.value?.etc ?? "정보 없음"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoSection(String title, String content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         Text(content, style: TextStyle(fontSize: 16)),
//         SizedBox(height: 16),
//       ],
//     );
//   }
// }
