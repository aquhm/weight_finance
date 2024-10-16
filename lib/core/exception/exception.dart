import 'package:dio/dio.dart';

class MultiRequestException implements Exception {
  final Map<String, dynamic> errors;
  final List<Response> partialResponses;

  MultiRequestException(this.errors, this.partialResponses);

  @override
  String toString() => 'MultiRequestException: $errors';
}

class RequestCancelledException implements Exception {
  final String message;
  final List<Response> partialResponses;

  RequestCancelledException(this.message, this.partialResponses);

  @override
  String toString() => 'RequestCancelledException: $message';
}
