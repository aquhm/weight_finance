import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:weight_finance/extension/unity_conversion.dart';
import 'package:weight_finance/feature/bank_rate/common/banking_products_screen.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
import 'package:weight_finance/feature/metal_price/presentation/bloc/commodity_price_bloc.dart';
import 'package:weight_finance/feature/metal_price/presentation/pages/commodity_price_detail_screen.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/routes.dart';

class CommodityPricesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalAPI.di.get<CommodityPricesBloc>(),
      child: const CommodityPricesView(),
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
      return _buildCommodityList(context, state, commodityData);
    } else if (state is CommodityPricesError) {
      return Center(child: Text(state.message));
    }
    return Container();
  }

  Widget _buildUnitButton(BuildContext context, String currentUnit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => _showUnitSelectionDialog(context, currentUnit),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
            foregroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '단위: ${UnitConversion.getUnitData(currentUnit).name}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 24),
            ],
          ),
        ),
      ],
    );
  }

  void _showUnitSelectionDialog(BuildContext context, String currentUnit) {
    final commodityPricesBloc = BlocProvider.of<CommodityPricesBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: commodityPricesBloc,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('단위 선택'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: UnitConversion.units.map((unitData) {
                    return _buildRadioListTile(context, unitData.name, unitData.code, currentUnit, setState);
                  }).toList(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRadioListTile(BuildContext context, String title, String value, String groupValue, StateSetter setState) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            context.read<CommodityPricesBloc>().add(ChangeUnit(newValue));
          });
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildCommodityList(BuildContext context, CommodityPricesLoaded state, dynamic commodityData) {
    if (state.data.metals.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildUnitButton(context, state.unit),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.data.metals.length,
            itemBuilder: (context, index) {
              final metal = state.data.metals.keys.elementAt(index);
              final metalData = state.data.metals[metal];

              if (metalData == null || metalData.timeframes["5d"] == null) {
                return const Center(child: Text('Data not available for this metal'));
              }

              final timeFrame = metalData.timeframes["5d"];
              return _buildItem(context, metal, "5일", timeFrame!, state.currency, state.unit, metalData);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, String metal, String timeframe, List<PricePointEntity> pricePoints, String currency, String unit,
      MetalEntity metalEntity) {
    if (pricePoints.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$metal: No price data available for the selected timeframe'),
        ),
      );
    }

    final latestPrice = pricePoints.last.price;
    final convertedPrice = UnitConversion.convertPrice(latestPrice, 'oz', unit);

    return GestureDetector(
      onTap: () {
        context.push('/finance_commodity_detail',
            extra: CommodityDetailArgs(
              metal: metal,
              metalEntity: metalEntity,
              currency: currency,
              unit: unit,
            ));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(metal, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Latest: ${convertedPrice.toStringAsFixed(2)} $currency/$unit'),
                ],
              ),
              SizedBox(
                width: 120,
                height: 60,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: pricePoints
                            .map((e) => FlSpot(
                                  DateTime.parse(e.date).millisecondsSinceEpoch.toDouble(),
                                  UnitConversion.convertPrice(e.price, 'oz', unit),
                                ))
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
