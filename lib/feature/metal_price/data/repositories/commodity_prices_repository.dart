import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/metal_price/data/data_sources/remote/abstract_commodity_price_api.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
import 'package:weight_finance/feature/metal_price/domain/repositories/abstract_commodity_prices_repository.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/managers/financial_data_manager.dart';

class CommodityPricesRepositoryImpl implements ICommodityPricesRepository {
  final ICommodityPricesApi commodityPricesApi;
  final FinancialDataManager _financialDataManager = GlobalAPI.managers.financialDataManager;

  CommodityPricesRepositoryImpl({required this.commodityPricesApi});

  @override
  Future<Either<Failure, CommodityPricesEntity>> getCommodityPrices() async {
    try {
      var cachedData = _financialDataManager.commodityPrices;
      if (cachedData.metals.isEmpty) {
        final result = await commodityPricesApi.getCommodityPrices();

        return result.fold(
          (failure) => Left(failure),
          (dto) {
            final entity = dto.toEntity();
            _financialDataManager.commodityPrices = entity;
            return Right(entity);
          },
        );
      } else {
        return Right(cachedData);
      }
    } catch (e) {
      return Left(Failure.unexpectedError(e.toString()));
    }
  }
}
