import 'package:weight_finance/managers/base_manager.dart';
import 'package:weight_finance/models/base_model.dart';
import 'package:weight_finance/models/static/onboarding/onboarding_model.dart';

class ModelManager implements IManager {
  // 모든 모델들을 리스트로 관리
  final List<BaseModel> _models = [];

  // // private 생성자
  // ModelManager._internal();
  //
  // // 싱글톤 인스턴스
  // static final ModelManager _instance = ModelManager._internal();
  //
  // // 외부에서 인스턴스를 얻기 위한 정적 메소드
  // static ModelManager get instance => _instance;

  ModelManager() {
    _initializeModels();
  }

  void _initializeModels() {
    _models.add(OnboardingModel());
    _loadAllModels();
  }

  // 모든 모델의 데이터를 로드
  void _loadAllModels() {
    for (var model in _models) {
      model.init();
    }
  }

  // 모든 모델의 데이터를 Clear
  void _clearAllModels() {
    for (var model in _models) {
      model.clear();
    }
  }

  @override
  void clear() {
    _clearAllModels();
  }

  @override
  void init() {
    _initializeModels();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
