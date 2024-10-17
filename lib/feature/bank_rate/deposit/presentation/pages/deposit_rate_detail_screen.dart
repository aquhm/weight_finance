import 'package:flutter/material.dart';
import 'package:weight_finance/feature/bank_rate/common/widget/financial_product_detail_screen.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';

class DepositRatesDetailScreen extends FinancialProductDetailScreen<DepositProductEntity> {
  const DepositRatesDetailScreen({super.key, required super.product});

  @override
  FinancialProductDetailScreenState<DepositProductEntity> createState() => _DepositRatesDetailScreenState();
}

class _DepositRatesDetailScreenState extends FinancialProductDetailScreenState<DepositProductEntity> {
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

    rateList.sort((a, b) => int.parse(a.key.substring(1)).compareTo(int.parse(b.key.substring(1))));

    return buildRateCardGrid(rateList, "");
  }
}
