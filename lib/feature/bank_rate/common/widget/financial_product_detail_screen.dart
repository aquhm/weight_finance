import 'package:flutter/material.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_rate.dart';
import 'package:weight_finance/feature/bank_rate/common/financial_product.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/data/assets/bank_logo_asset.dart';
import 'package:weight_finance/utils/currency_formatter.dart';

abstract class FinancialProductDetailScreen<T extends FinancialProduct> extends StatefulWidget {
  final T product;

  const FinancialProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  FinancialProductDetailScreenState<T> createState();
}

abstract class FinancialProductDetailScreenState<T extends FinancialProduct> extends State<FinancialProductDetailScreen<T>>
    with SingleTickerProviderStateMixin {
  final BankLogoAssets bankLogoAssets = GlobalAPI.managers.assetsManager.bankLogoAssets;
  late TabController _tabController;

  @protected
  bool isCompoundInterest = false;
  @protected
  late bool isTabMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    bool hasCompoundInterest = widget.product.compoundRateList.isNotEmpty;
    bool hasSimpleInterest = widget.product.simpleRateList.isNotEmpty;
    isTabMode = hasCompoundInterest && hasSimpleInterest;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        isCompoundInterest = !isCompoundInterest;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productName),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // 공유 기능 구현
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildRateInfo(),
            _buildInterestByPeriod(),
            Divider(thickness: 4),
            _buildJoinMethods(),
            Divider(thickness: 4),
            _buildDetailedProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          bankLogoAssets.getAsset(widget.product.bankId, params: {'size': 60.0}),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.bankName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  widget.product.productName,
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateInfo() {
    final rate = widget.product.getRateData(12);
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("금리 정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text("(12개월 기준)", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
          SizedBox(height: 8),
          _buildRateInfoRow("기본 금리", "${rate?.defaultRate ?? 'N/A'}%"),
          _buildRateInfoRow("최대 금리", "${rate?.preferentialRate ?? 'N/A'}%", isHighlighted: true),
          _buildRateInfoRow("최고 한도", _formatMaxLimit()),
        ],
      ),
    );
  }

  Widget _buildRateInfoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMaxLimit() {
    int? maxLimit = widget.product.maximumAmount;
    return maxLimit == null || maxLimit == 0 ? "정보없음" : CurrencyFormatter.formatKoreanWon(maxLimit);
  }

  Widget _buildInterestByPeriod() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("기간별 금리 정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildInterestTypeToggle(),
          SizedBox(height: 16),
          buildRateCards(),
        ],
      ),
    );
  }

  Widget _buildInterestTypeToggle() {
    if (isTabMode) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.grey[800],
          unselectedLabelColor: Colors.grey[600],
          tabs: [
            Tab(text: "단리"),
            Tab(text: "복리"),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @protected
  Widget buildRateCards(); // 추상 메서드로 선언

  @protected
  Widget buildRateCardGrid(List<MapEntry<String, FinancialRate>> rates, String title) {
    rates.sort((a, b) => a.value.month.compareTo(b.value.month));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: rates.length,
          itemBuilder: (context, index) {
            var entry = rates[index];
            FinancialRate rate = entry.value;
            return _buildRateCard(rate);
          },
        ),
      ],
    );
  }

  Widget _buildRateCard(FinancialRate rate) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${rate.month}개월",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                if (!isTabMode)
                  Text(
                    isCompoundInterest ? '(복리)' : '(단리)',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              "${rate.defaultRate}%",
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinMethods() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("가입 방법", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.joinWays
                .map((way) => Chip(
                      label: Text(way.toDisplayString()),
                      backgroundColor: Colors.grey[300],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedProductInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("상세 상품 정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildInfoSection("만기 후 이자율", widget.product.maturityRate ?? "정보 없음"),
          _buildInfoSection("우대조건", widget.product.preferentialTreatment ?? "정보 없음"),
          _buildInfoSection("기타 유의사항", widget.product.etc ?? "정보 없음"),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
      ],
    );
  }
}
