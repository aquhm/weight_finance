// import 'package:get/get.dart';
// import 'package:weight_finance/global_api.dart';
// import 'package:weight_finance/data/financialData/financial_data.dart';
// import 'package:weight_finance/managers/financial_data_manager.dart';
//
// class FinanceScreenController extends GetxController {
//   final FinancialDataManager dataManager = GlobalAPI.managers.financialDataManager;
//   final RxList<FinancialInfo> depositList = <FinancialInfo>[].obs;
//   final RxList<FinancialInfo> savingList = <FinancialInfo>[].obs;
//   final RxInt depositDisplayedCount = 20.obs;
//   final RxInt savingDisplayedCount = 20.obs;
//   final Rx<FinancialProductType> currentType = FinancialProductType.deposit.obs;
//   final RxInt expandedIndex = (-1).obs;
//   final RxString searchQuery = ''.obs;
//   final RxList<FinancialInfo> filteredDepositList = <FinancialInfo>[].obs;
//   final RxList<FinancialInfo> filteredSavingList = <FinancialInfo>[].obs;
//
//   List<FinancialInfo> get currentList => currentType.value == FinancialProductType.deposit ? depositList : savingList;
//   int get currentDisplayedCount => currentType.value == FinancialProductType.deposit ? depositDisplayedCount.value : savingDisplayedCount.value;
//
//   late Worker _everWorker;
//
//   @override
//   void onInit() {
//     super.onInit();
//     ever(searchQuery, (_) => filterList());
//
//     GlobalAPI.logger.d("FinanceScreenController onInit");
//     loadInitialData();
//     _everWorker = ever(currentType, (_) => resetExpandedItem());
//   }
//
//   @override
//   void onClose() {
//     GlobalAPI.logger.d("FinanceScreenController onClose");
//
//     _everWorker.dispose();
//
//     // 리스트 초기화
//     depositList.clear();
//     savingList.clear();
//
//     super.onClose();
//   }
//
//   void loadInitialData() {
//     loadData(FinancialProductType.deposit);
//     loadData(FinancialProductType.saving);
//   }
//
//   void loadData(FinancialProductType type) {
//     var fullList = switch (type) {
//       FinancialProductType.deposit => dataManager.depositData.depositInfos.values.toList(),
//       FinancialProductType.saving => dataManager.savingData.savingInfos.values.toList(),
//     };
//
//     fullList = fullList.where((info) => info.getRate(12) > 0).toList();
//     fullList.sort((a, b) => b.getRate(12).compareTo(a.getRate(12)));
//
//     if (type == FinancialProductType.deposit) {
//       depositList.value = fullList;
//       depositDisplayedCount.value = 20.clamp(0, fullList.length);
//     } else {
//       savingList.value = fullList;
//       savingDisplayedCount.value = 20.clamp(0, fullList.length);
//     }
//   }
//
//   void loadMoreItems() {
//     if (currentType.value == FinancialProductType.deposit) {
//       depositDisplayedCount.value = (depositDisplayedCount.value + 20).clamp(0, depositList.length);
//     } else {
//       savingDisplayedCount.value = (savingDisplayedCount.value + 20).clamp(0, savingList.length);
//     }
//   }
//
//   void changeProductType(FinancialProductType type) {
//     if (currentType.value != type) {
//       currentType.value = type;
//       resetExpandedItem();
//     }
//   }
//
//   void toggleExpansion(int index) {
//     expandedIndex.value = expandedIndex.value == index ? -1 : index;
//   }
//
//   void resetExpandedItem() {
//     expandedIndex.value = -1;
//   }
//
//   List<FinancialInfo> getDisplayedList() {
//     return currentList.take(currentDisplayedCount).toList();
//   }
//
//   void setSearchQuery(String query) {
//     searchQuery.value = query;
//     filterList();
//   }
//
//   void filterList() {
//     if (searchQuery.value.isEmpty) {
//       filteredDepositList.value = depositList;
//       filteredSavingList.value = savingList;
//     } else {
//       var query = searchQuery.value.toLowerCase();
//       filteredDepositList.value =
//           depositList.where((info) => info.bankName.toLowerCase().contains(query) || info.productName.toLowerCase().contains(query)).toList();
//       filteredSavingList.value =
//           savingList.where((info) => info.bankName.toLowerCase().contains(query) || info.productName.toLowerCase().contains(query)).toList();
//     }
//   }
// }
