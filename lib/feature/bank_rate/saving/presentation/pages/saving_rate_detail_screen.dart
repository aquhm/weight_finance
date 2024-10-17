import 'package:flutter/material.dart';
import 'package:weight_finance/feature/bank_rate/common/widget/financial_product_detail_screen.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';

class SavingRatesDetailScreen extends FinancialProductDetailScreen<SavingProductEntity> {
  const SavingRatesDetailScreen({Key? key, required SavingProductEntity product}) : super(key: key, product: product);

  @override
  FinancialProductDetailScreenState<SavingProductEntity> createState() => _SavingRatesDetailScreenState();
}

class _SavingRatesDetailScreenState extends FinancialProductDetailScreenState<SavingProductEntity> {
  @override
  Widget buildRateCards() {
    var rateList = widget.product.simpleRateList;
    if (isTabMode) {
      rateList = isCompoundInterest ? widget.product.compoundRateList : widget.product.simpleRateList;
    } else {
      if (widget.product.compoundRateList.isNotEmpty && widget.product.simpleRateList.isEmpty) {
        rateList = widget.product.compoundRateList;
      } else if (widget.product.compoundRateList.isEmpty && widget.product.simpleRateList.isNotEmpty) {
        rateList = widget.product.simpleRateList;
      }
    }

    var regularRates = rateList.where((entry) => entry.key[1] == 'S').toList();
    var freeRates = rateList.where((entry) => entry.key[1] == 'F').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (regularRates.isNotEmpty) ...[
          buildRateCardGrid(regularRates, "정액적립"),
          SizedBox(height: 16),
        ],
        if (freeRates.isNotEmpty) ...[
          buildRateCardGrid(freeRates, "자유적립"),
        ],
      ],
    );
  }
}
