import 'package:weight_finance/feature/bank_rate/common/widget/financial_product_screen.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
import 'package:weight_finance/feature/bank_rate/saving/presentation/bloc/saving_rate_bloc.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';

class SavingRatesScreen extends FinancialProductScreen<SavingProductEntity, SavingRateBloc> {
  SavingRatesScreen()
      : super(
          title: "적금 상품",
          productType: FinancialProductType.saving,
          detailRoute: '/finance_saving_detail',
        );
}
