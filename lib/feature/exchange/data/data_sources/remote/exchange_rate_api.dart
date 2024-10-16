import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/network/dio_client.dart';
import 'package:weight_finance/feature/exchange/data/data_sources/remote/abstract_exchange_rate_api.dart';
import 'package:weight_finance/feature/exchange/data/models/exchange_rate_model.dart';

class ExchangeRateApiImpl implements IExchangeRateApi {
  final DioClient dioClient;

  static const BASE_URL = "https://weight500-finance.s3.ap-northeast-2.amazonaws.com/exchange_rates.json";

  ExchangeRateApiImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<ExchangeRateModel>>> getExchangeRateList() async {
    //final today = DateFormat('yyyyMMdd').format(DateTime.now());

    try {
      final response = await dioClient.get(
        BASE_URL,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty && data[0]['result'] == 1) {
          final List<ExchangeRateModel> exchangeRates = data.map((item) => ExchangeRateModel.fromMap(item)).toList();
          return Right(exchangeRates);
        } else {
          return Left(Failure.serverError('No exchange rate data available'));
        }
      } else {
        return Left(Failure.serverError('Server responded with status code: ${response.statusCode}'));
      }
    } on DioException catch (ex) {
      if (ex.response != null) {
        if (ex.response!.data != null) {
          return Left(Failure.serverError(ex.response!.data.toString())); // 서버 오류와 함께 메시지 전달
        } else {
          return Left(Failure.serverError(ex.response!.statusMessage ?? '서버 응답 오류')); // 상태 메시지 전달
        }
      } else {
        return Left(Failure.networkError(ex.message ?? '네트워크 오류')); // 네트워크 오류 메시지 전달
      }
    } catch (ex) {
      return Left(Failure.unexpectedError(ex.toString())); // 예상치 못한 오류 메시지 전달
    }
  }
}
