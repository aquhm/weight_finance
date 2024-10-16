import 'package:get/get.dart';
import 'package:weight_finance/controllers/finance_detail_controller.dart';
import 'package:weight_finance/controllers/finance_screen_controller.dart';
import 'package:weight_finance/controllers/theme_controller.dart';
import 'package:weight_finance/managers/base_manager.dart';

class ControllerManager implements IManager {
  //ThemeController get themeController => Get.find<ThemeController>();
  //FinanceScreenController get financeScreenController => Get.find<FinanceScreenController>();
  FinanceDetailController get financeDetailController => Get.find<FinanceDetailController>();

  @override
  void init() {
    //Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    //Get.lazyPut<FinanceScreenController>(() => FinanceScreenController(), fenix: true);
    Get.lazyPut<FinanceDetailController>(() => FinanceDetailController(), fenix: true);
  }

  @override
  void clear() {
    // 필요한 경우 컨트롤러의 데이터를 초기화하는 로직을 추가합니다.
  }

  @override
  void dispose() {
    //Get.delete<ThemeController>();
    //Get.delete<FinanceScreenController>();
    Get.delete<FinanceDetailController>();
  }
}
