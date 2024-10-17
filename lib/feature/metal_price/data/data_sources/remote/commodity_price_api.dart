import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/network/dio_client.dart';
import 'package:weight_finance/feature/metal_price/data/data_sources/remote/abstract_commodity_price_api.dart';
import 'package:weight_finance/feature/metal_price/data/models/commodity_prices_model.dart';
import 'dart:convert';

class CommodityPricesApiImpl implements ICommodityPricesApi {
  final DioClient dioClient;

  static const BASE_URL = "https://weight500-finance.s3.ap-northeast-2.amazonaws.com/all_metal_prices.json";

  CommodityPricesApiImpl({required this.dioClient});

  @override
  Future<Either<Failure, CommodityPricesDto>> getCommodityPrices() async {
    try {
      final response = await dioClient.get(BASE_URL);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data != null) {
          if (data is Map<String, dynamic>) {
            var commodityPrices = CommodityPricesDto.fromJson(data);
            return Right(commodityPrices);
          } else if (data is String) {
            var jsonData = json.decode(data);
            if (jsonData is Map<String, dynamic>) {
              var commodityPrices = CommodityPricesDto.fromJson(jsonData);
              return Right(commodityPrices);
            }
          }
          return Left(Failure.serverError('Unexpected data format from server'));
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
