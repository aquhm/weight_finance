class NullSafetyParser {
  static String asString(dynamic value) {
    return value?.toString() ?? '';
  }

  static double asDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int asInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool asBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }

  static List asList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;
    return [];
  }

  static Map asMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) return value;
    return {};
  }

  static T asType<T>(dynamic value, T defaultValue) {
    if (value == null) return defaultValue;
    if (value is T) return value;
    return defaultValue;
  }
}
