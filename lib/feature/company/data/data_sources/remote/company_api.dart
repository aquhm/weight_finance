import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/network/dio_client.dart';
import 'package:weight_finance/feature/company/data/data_sources/remote/abstract_company_api.dart';
import 'package:weight_finance/feature/company/data/models/company_model.dart';

class CompanyApiImpl implements ICompanyApi {
  final DioClient dioClient;

  static const BASE_URL = "https://weight500-finance.s3.ap-northeast-2.amazonaws.com/company.json";

  CompanyApiImpl({required this.dioClient});

  @override
  Future<Either<Failure, Map<String, CompanyModelDto>>> getCompanies() async {
    try {
      final response = await dioClient.get(
        BASE_URL,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data.isNotEmpty) {
          Map<String, CompanyModelDto> depositModels = {};

          var baseList = data["base_list"] as List<dynamic>;
          var optionList = data["option_list"] as List<dynamic>;

          for (var item in baseList) {
            var data = CompanyModelDto.fromMap(item);

            if (depositModels.containsKey(data.finCoNo) == false) {
              depositModels[data.finCoNo] = data;
            }
          }

          for (var option in optionList) {
            var data = CompanyAreaModelDto.fromMap(option);

            if (depositModels.containsKey(data.finCoNo)) {
              depositModels[data.finCoNo]?.addArea(data);
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
