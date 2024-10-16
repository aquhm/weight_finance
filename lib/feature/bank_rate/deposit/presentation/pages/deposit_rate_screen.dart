import 'package:weight_finance/feature/bank_rate/common/widget/financial_product_screen.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';
import 'package:weight_finance/feature/bank_rate/deposit/presentation/bloc/deposit_rate_bloc.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';

class DepositRatesScreen extends FinancialProductScreen<DepositProductEntity, DepositRateBloc> {
  DepositRatesScreen()
      : super(
          title: "예금 상품",
          productType: FinancialProductType.deposit,
          detailRoute: '/finance_deposit_detail',
        );
}
