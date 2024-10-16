import 'package:weight_finance/feature/bank_rate/common/financial_product_bloc.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';

part 'deposit_rate_event.dart';
part 'deposit_rate_state.dart';

class DepositRateBloc extends FinancialProductBloc<DepositProductEntity> {
  DepositRateBloc({required super.globalFinancialBloc});
}
