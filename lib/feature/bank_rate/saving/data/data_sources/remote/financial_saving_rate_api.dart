import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/network/dio_client.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/data_sources/remote/abstract_financial_saving_rate_api.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/models/saving_model.dart';
import 'package:weight_finance/global_api.dart';

class FinancialSavingRateImpl implements IFinancialSavingRateApi {
  final DioClient dioClient;

  static const BASE_URL = "https://weight500-finance.s3.ap-northeast-2.amazonaws.com/saving.json";

  FinancialSavingRateImpl({required this.dioClient});

  @override
  Future<Either<Failure, Map<FinancialKey, SavingModelDto>>> getSavings() async {
    int i = 0;
    try {
      final response = await dioClient.get(
        BASE_URL,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data.isNotEmpty) {
          final List<SavingModelDto> savings = [];

          Map<FinancialKey, SavingModelDto> savingModels = {};

          var baseList = data["base_list"] as List<dynamic>;
          var optionList = data["option_list"] as List<dynamic>;

          for (var item in baseList) {
            var data = SavingModelDto.fromMap(item);
            final key = FinancialKey(data.finCoNo, data.finPrdtCd);
            if (savingModels.containsKey(key) == false) {
              savingModels[key] = data;
            }
            i++;
          }

          for (var option in optionList) {
            var data = SavingRateModelDto.fromMap(option);

            final key = FinancialKey(data.finCoNo, data.finPrdtCd);

            if (savingModels.containsKey(key)) {
              savingModels[key]?.addDetails(data);
            }
          }

          if (savingModels.isNotEmpty) {
            return Right(savingModels);
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
      GlobalAPI.logger.d("===========>i = $i");
      return Left(Failure.unexpectedError(ex.toString()));
    }
  }
}
