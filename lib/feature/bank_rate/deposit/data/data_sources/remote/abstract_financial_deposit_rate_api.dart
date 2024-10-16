import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/models/deposit_model.dart';

abstract interface class IFinancialDepositRateApi {
  Future<Either<Failure, Map<FinancialKey, DepositModelDto>>> getDeposits();
}
