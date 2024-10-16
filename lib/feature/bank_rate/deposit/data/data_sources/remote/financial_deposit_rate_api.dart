import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/network/dio_client.dart';

import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/data_sources/remote/abstract_financial_deposit_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/models/deposit_model.dart';

class FinancialDepositRateImpl implements IFinancialDepositRateApi {
  final DioClient dioClient;

  static const BASE_URL = "https://weight500-finance.s3.ap-northeast-2.amazonaws.com/deposit.json";

  FinancialDepositRateImpl({required this.dioClient});

  @override
  Future<Either<Failure, Map<FinancialKey, DepositModelDto>>> getDeposits() async {
    try {
      final response = await dioClient.get(
        BASE_URL,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data.isNotEmpty) {
          final List<DepositModelDto> deposits = [];

          Map<FinancialKey, DepositModelDto> depositModels = {};

          var baseList = data["base_list"] as List<dynamic>;
          var optionList = data["option_list"] as List<dynamic>;

          for (var item in baseList) {
            var data = DepositModelDto.fromMap(item);
            final key = FinancialKey(data.finCoNo, data.finPrdtCd);
            if (depositModels.containsKey(key) == false) {
              depositModels[key] = data;
            }
          }

          for (var option in optionList) {
            var data = DepositRateModelDto.fromMap(option);

            final key = FinancialKey(data.finCoNo, data.finPrdtCd);

            if (depositModels.containsKey(key)) {
              depositModels[key]?.addDetails(data);
            }
          }

          if (depositModels.isNotEmpty) {
            return Right(depositModels);
          } else {
            return Left(Failure.serverError('No valid deposit data available'));
          }
        } else {
          return Left(Failure.serverError('Empty response from server'));
        }
      } else {
        return Left(Failure.serverError('Server responded with status code: ${response.statusCode}'));
      }
    } on DioException catch (ex) {
      if (ex.response != null) {
        return Left(Failure.serverError(ex.response?.statusMessage ?? 'Server Error'));
      } else {
        return Left(Failure.networkError(ex.message ?? 'Network Error'));
      }
    } catch (ex) {
      return Left(Failure.unexpectedError(ex.toString()));
    }
  }
}
