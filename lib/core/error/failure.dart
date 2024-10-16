import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError([String? message]) = _ServerError;
  const factory Failure.networkError([String? message]) = NetworkError;
  const factory Failure.parseError([String? message]) = ParseError;
  const factory Failure.unexpectedError([String? message]) = UnexpectedError;
}
