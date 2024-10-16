abstract class Assets<T> {
  String get basepath;

  Future<void> init();
  T getAsset(String key, {Map<String, dynamic>? params});
}
