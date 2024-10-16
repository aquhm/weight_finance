import 'package:dartz/dartz.dart';
import 'package:weight_finance/core/error/failure.dart';
import 'package:weight_finance/data/financialData/financial_data.dart';
import 'package:weight_finance/feature/bank_rate/deposit/data/models/deposit_model.dart';
import 'package:weight_finance/feature/bank_rate/saving/data/models/saving_model.dart';

abstract interface class IFinancialSavingRateApi {
  Future<Either<Failure, Map<FinancialKey, SavingModelDto>>> getSavings();
}
