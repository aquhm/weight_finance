import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
import 'package:weight_finance/feature/metal_price/presentation/bloc/commodity_price_bloc.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
import 'package:weight_finance/global_api.dart';

class CommodityPricesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalAPI.di.get<CommodityPricesBloc>(),
      child: CommodityPricesView(),
    );
  }
}

class CommodityPricesView extends StatelessWidget {
  const CommodityPricesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommodityPricesBloc, CommodityPriceState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Commodity Prices'),
              actions: [
                if (state is CommodityPricesLoaded) ...[
                  _buildCurrencyButton(context, state.currency),
                  _buildUnitButton(context, state.unit),
                ],
              ],
            ),
            body: _buildBody(context, state),
          );
        });
  }

  Widget _buildBody(BuildContext context, CommodityPriceState state) {
    return BlocBuilder<GlobalFinancialBloc, GlobalFinancialState>(
      builder: (context, globalState) {
        return switch (globalState) {
          GlobalFinancialInitial() => const Center(child: Text('금융 데이터 초기화 중...')),
          GlobalFinancialLoading() when globalState.isLoading(FinancialProductType.commodity) => const Center(child: CircularProgressIndicator()),
          GlobalFinancialLoaded(data: var data) => _buildCommodityContent(context, state, data[FinancialProductType.commodity]),
          GlobalFinancialError(:final message) => Center(child: Text('Error: $message')),
          _ => const Center(child: Text('알 수 없는 글로벌 상태')),
        };
      },
    );
  }

  Widget _buildCommodityContent(BuildContext context, CommodityPriceState state, dynamic commodityData) {
    if (state is CommodityPricesInitial) {
      context.read<CommodityPricesBloc>().add(LoadCommodityPrices());
      return const Center(child: CircularProgressIndicator());
    } else if (state is CommodityPricesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CommodityPricesLoaded) {
      return _buildCommodityList(state, commodityData);
    } else if (state is CommodityPricesError) {
      return Center(child: Text(state.message));
    }
    return Container();
  }

  Widget _buildCurrencyButton(BuildContext context, String currentCurrency) {
    return PopupMenuButton<String>(
      onSelected: (String currency) {
        context.read<CommodityPricesBloc>().add(ChangeCurrency(currency));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'USD',
          child: Text('USD'),
        ),
        const PopupMenuItem<String>(
          value: 'EUR',
          child: Text('EUR'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(currentCurrency),
      ),
    );
  }

  Widget _buildUnitButton(BuildContext context, String currentUnit) {
    return PopupMenuButton<String>(
      onSelected: (String unit) {
        context.read<CommodityPricesBloc>().add(ChangeUnit(unit));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'oz',
          child: Text('oz'),
        ),
        const PopupMenuItem<String>(
          value: 'g',
          child: Text('g'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(currentUnit),
      ),
    );
  }

  Widget _buildCommodityList(CommodityPricesLoaded state, dynamic commodityData) {
    if (state.data.metals.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: state.data.metals.length,
      itemBuilder: (context, index) {
        final metal = state.data.metals.keys.elementAt(index);
        final metalData = state.data.metals[metal]!;

        final timeFrame = metalData.timeframes["5d"];

        return _buildItem(metal, "5d", timeFrame!, state.currency, state.unit);
      },
    );
  }

  Widget _buildItem(String metal, String timeframe, List<PricePointEntity> pricePoints, String currency, String unit) {
    final latestPrice = pricePoints.isNotEmpty ? pricePoints.last.price : 0.0;
    final priceData = pricePoints
        .map((e) => FlSpot(
              DateTime.parse(e.date).millisecondsSinceEpoch.toDouble(),
              e.price,
            ))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$metal - $timeframe', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text('Latest: $latestPrice $currency/$unit'),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: priceData,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
