import 'package:weight_finance/services/financial_data_service.dart';
import 'package:weight_finance/services/base_service.dart';

class Services {
  final List<IService> _services = [];

  late FinancialDataService _financialDataService;

  FinancialDataService get financialDataService => _financialDataService;

  Services() {
    _financialDataService = FinancialDataService();

    _services.addAll([
      _financialDataService,
    ]);
  }

  void init() async {
    for (var service in _services) {
      service.init();
    }
  }

  void clear() {
    for (var service in _services) {
      service.clear();
    }
  }

  void dispose() {
    for (var service in _services) {
      service.dispose();
    }
  }
}
