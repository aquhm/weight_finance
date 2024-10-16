import 'dart:io';

class CsvHelper {
  static String getEndOfLine() {
    return Platform.isWindows ? "\r\n" : "\n";
  }
}
