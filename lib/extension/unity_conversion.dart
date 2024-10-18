// unit_conversion.dart
class UnitConversion {
  static const List<UnitData> units = [
    UnitData('트로이온스', 'oz', 1),
    UnitData('그램', 'g', 31.1034768),
    UnitData('밀리그램', 'mg', 31103.4768),
    UnitData('킬로그램', 'kg', 0.0311034768),
    UnitData('파운드', 'lb', 0.0685714286),
  ];

  static UnitData get oz => getUnitData('oz');
  static UnitData get g => getUnitData('g');
  static UnitData get mg => getUnitData('mg');
  static UnitData get kg => getUnitData('kg');
  static UnitData get lb => getUnitData('lb');

  static double convertPrice(double price, String fromUnit, String toUnit) {
    final fromConversion = units.firstWhere((unit) => unit.code == fromUnit).conversion;
    final toConversion = units.firstWhere((unit) => unit.code == toUnit).conversion;
    return price * fromConversion / toConversion;
  }

  static UnitData getUnitData(String code) {
    return units.firstWhere((unit) => unit.code == code);
  }
}

class UnitData {
  final String name;
  final String code;
  final double conversion;

  const UnitData(this.name, this.code, this.conversion);
}
