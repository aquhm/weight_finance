import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weight_finance/core/di/dependency_injector.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
import 'package:weight_finance/managers/managers.dart';
import 'package:weight_finance/services/services.dart';

class GlobalAPI {
  static late Logger _logger;

  static late Managers _managers;
  static late Services _services;
  static late DependencyInjector _dependencyInjector;
  static late PackageInfo _packageInfo;

  static Logger get logger => _logger;
  static Managers get managers => _managers;
  static Services get services => _services;
  static DependencyInjector get di => _dependencyInjector;
  static PackageInfo get packageInfo => _packageInfo;

  static Future init() async {
    _logger = Logger(
      printer: PrettyPrinter(),
    );

    _packageInfo = await PackageInfo.fromPlatform();

    _services = Services()..init();
    _managers = Managers()..init();

    _dependencyInjector = DependencyInjector()
      ..init()
      ..prepare();

    _logger.d("GlobalAPI init()");
  }

  static void clear() {
    _services?.init();
    _managers?.clear();

    _logger.d("GlobalAPI clear()");
  }

  static void dispose() {
    _services?.dispose();
    _managers?.dispose();

    _logger.d("GlobalAPI dispose()");
  }
}
