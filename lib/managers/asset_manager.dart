import 'package:weight_finance/data/asset.dart';
import 'package:weight_finance/data/assets/bank_logo_asset.dart';
import 'package:weight_finance/managers/base_manager.dart';

class AssetsManager implements IManager {
  final Map<Type, Assets> _assets = {};

  BankLogoAssets get bankLogoAssets => getAsset<BankLogoAssets>();

  @override
  void clear() {
    // 필요한 경우 구현
  }

  @override
  void dispose() {
    _assets.clear();
  }

  @override
  void init() {
    _registerAsset<BankLogoAssets>(BankLogoAssets());

    bankLogoAssets.init();
  }

  void _registerAsset<T extends Assets>(T asset) {
    _assets[T] = asset;
  }

  T getAsset<T extends Assets>() {
    final asset = _assets[T];
    if (asset == null) {
      throw Exception('Asset of type $T not registered');
    }
    return asset as T;
  }
}
