import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';
import 'package:weight_finance/services/base_service.dart';

class DownloadResult {
  final String filename;
  final String content;

  DownloadResult(this.filename, this.content);
}

class FinancialDataService implements IService {
  late String _s3BaseUrl;

  Map<String, List<List<dynamic>>> _cachedData = {};

  @override
  void clear() {
    _cachedData.clear();
  }

  @override
  void dispose() {
    clear();
  }

  @override
  void init() {
    _s3BaseUrl = "https://weight500-finance.s3.ap-northeast-2.amazonaws.com/";
  }

  Future<List<Tuple2<String, String>>> fetchData(List<String> fileNames) async {
    try {
      var downloadFutures = fileNames.map((fileName) => _download(fileName)).toList();

      // 모든 다운로드가 완료될 때까지 기다리기
      var results = await Future.wait(downloadFutures);

      return results;
    } catch (e) {
      print('Error during file downloads: $e');
      return [];
    }
  }

  Future<Tuple2<String, String>> _download(String fileName) async {
    final fileUrl = '$_s3BaseUrl$fileName';

    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);
      return Tuple2(fileName, decodedBody);
    } else {
      throw Exception('Failed to download $fileName');
    }
  }

  Future<bool> _shouldUpdate(String fileUrl, File localFile) async {
    final s3LastModified = await _getS3LastModified(fileUrl);
    final localLastModified = await localFile.lastModified();
    return s3LastModified.isAfter(localLastModified);
  }

  Future<DateTime> _getS3LastModified(String fileUrl) async {
    final response = await http.head(Uri.parse(fileUrl));
    final lastModifiedString = response.headers['last-modified'];
    return HttpDate.parse(lastModifiedString!);
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<List<dynamic>>> loadLocalData(String fileName) async {
    if (_cachedData.containsKey(fileName)) {
      return _cachedData[fileName]!;
    }

    final file = await _getLocalFile(fileName);
    if (await file.exists()) {
      final contents = await file.readAsString();
      _cachedData[fileName] = _parseCsvString(contents);
      return _cachedData[fileName]!;
    } else {
      throw Exception('Local file $fileName does not exist');
    }
  }

  List<List<dynamic>> _parseCsvString(String csvString) {
    try {
      return CsvToListConverter().convert(csvString);
    } catch (e) {
      print('Error parsing CSV: $e');
      throw Exception('Failed to parse CSV data');
    }
  }
}
