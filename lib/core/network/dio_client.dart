import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:weight_finance/core/exception/exception.dart';
import 'package:weight_finance/core/network/logger_interceptor.dart';

class DioClient {
  late final Dio _dio;
  DioClient()
      : _dio = Dio(
          BaseOptions(
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              responseType: ResponseType.json,
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30)),
        )..interceptors.addAll([LoggerInterceptor()]) {
    // SSL 인증서 검증 비활성화 (개발 환경에서만 사용)
    // (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    //   final client = HttpClient();
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    // (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('GET request cancelled', []);
      }
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('POST request cancelled', []);
      }
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('PUT request cancelled', []);
      }
      rethrow;
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('DELETE request cancelled', []);
      }
      rethrow;
    }
  }

  // HEAD METHOD
  Future<Map<String, List<String>>> head(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.head(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.headers.map;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('HEAD request cancelled', []);
      }
      rethrow;
    }
  }

  Future<void> downloadFile(
    String url,
    String savePath, {
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('File download cancelled', []);
      }
      rethrow;
    }
  }

  Future<Response> uploadFile(
    String url,
    File file, {
    String? filename,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      String fileName = filename ?? file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
        ...?data,
      });

      return await _dio.post(
        url,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('File upload cancelled', []);
      }
      rethrow;
    }
  }

  Future<Response> getWithTimeout(
    String url, {
    Duration connectTimeout = const Duration(seconds: 5),
    Duration receiveTimeout = const Duration(seconds: 3),
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        url,
        options: Options(
          sendTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        ),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('GET request with timeout cancelled', []);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw TimeoutException('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException('Receive timeout');
      }
      rethrow;
    }
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  Future<List<Response>> multipleRequests(
    List<String> urls, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    final responses = <Response>[];
    final errors = <String, dynamic>{};

    cancelToken ??= CancelToken();

    try {
      final futures = urls.map((url) => _dio
              .get(
            url,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: options,
            onReceiveProgress: onReceiveProgress,
          )
              .catchError((error) {
            errors[url] = error;
            return Response(
              requestOptions: RequestOptions(path: url),
              statusCode: error is DioException ? error.response?.statusCode : 500,
            );
          }));

      responses.addAll(await Future.wait(futures));

      if (errors.isNotEmpty) {
        throw MultiRequestException(errors, responses);
      }

      return responses;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException('Multiple requests cancelled', responses);
      }
      rethrow;
    } catch (e) {
      if (e is MultiRequestException) rethrow;
      throw MultiRequestException({'unknown': e}, responses);
    }
  }
}
