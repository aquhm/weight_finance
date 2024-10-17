import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/core/usecase/usecase.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
import 'package:weight_finance/feature/metal_price/domain/repositories/abstract_commodity_prices_repository.dart';

class GetCommodityPricesUseCase implements UseCase {
  final ICommodityPricesRepository repository;

  const GetCommodityPricesUseCase({required this.repository});

  @override
  Future<Either<Failure, CommodityPricesEntity>> call(params) async {
    return await repository.getCommodityPrices();
  }
}
