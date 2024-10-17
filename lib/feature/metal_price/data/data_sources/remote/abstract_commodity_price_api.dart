import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/feature/metal_price/data/models/commodity_prices_model.dart';

abstract interface class ICommodityPricesApi {
  Future<Either<Failure, CommodityPricesDto>> getCommodityPrices();
}
