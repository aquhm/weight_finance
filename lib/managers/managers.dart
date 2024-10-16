import 'package:weight_finance/managers/asset_manager.dart';
import 'package:weight_finance/managers/base_manager.dart';
import 'package:weight_finance/managers/controller_manager.dart';
import 'package:weight_finance/managers/model_manager.dart';

import 'financial_data_manager.dart';

class Managers {
  final List<IManager> _managers = [];

  late ControllerManager _controllerManager;
  late ModelManager _modelManager;
  late FinancialDataManager _financialDataManager;
  late AssetsManager _assetsManager;

  ControllerManager get controllerManager => _controllerManager;
  ModelManager get modelManager => _modelManager;
  FinancialDataManager get financialDataManager => _financialDataManager;
  AssetsManager get assetsManager => _assetsManager;

  Managers() {
    _controllerManager = ControllerManager();
    _modelManager = ModelManager();
    _financialDataManager = FinancialDataManager();
    _assetsManager = AssetsManager();

    _managers.addAll([_controllerManager, _modelManager, _financialDataManager, _assetsManager]);
  }

  void init() async {
    for (var manager in _managers) {
      manager.init();
    }
  }

  void clear() {
    for (var manager in _managers) {
      manager.clear();
    }
  }

  void dispose() {
    for (var manager in _managers) {
      manager.dispose();
    }
  }
}
