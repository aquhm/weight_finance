import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';

abstract interface class ICommodityPricesRepository {
  Future<Either<Failure, CommodityPricesEntity>> getCommodityPrices();
}
