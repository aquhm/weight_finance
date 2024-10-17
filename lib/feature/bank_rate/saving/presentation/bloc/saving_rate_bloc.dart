import 'package:weight_finance/feature/bank_rate/common/financial_product_bloc.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';

part 'saving_rate_event.dart';
part 'saving_rate_state.dart';

class SavingRateBloc extends FinancialProductBloc<SavingProductEntity> {
  SavingRateBloc({required super.globalFinancialBloc});
}
