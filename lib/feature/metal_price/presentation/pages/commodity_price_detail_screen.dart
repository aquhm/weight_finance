import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:weight_finance/extension/unity_conversion.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';

class CommodityDetailScreen extends StatefulWidget {
  final String metal;
  final MetalEntity metalData;
  final String currency;
  final String unit;

  const CommodityDetailScreen({
    Key? key,
    required this.metal,
    required this.metalData,
    required this.currency,
    required this.unit,
  }) : super(key: key);

  @override
  _CommodityDetailScreenState createState() => _CommodityDetailScreenState();
}

class _CommodityDetailScreenState extends State<CommodityDetailScreen> {
  String _selectedTimeFrame = '5d';
  final List<String> _timeFrames = ['5d', '30d', '6m', '1y', '5y', '20y'];
  Key _chartKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.metal} 상세 정보'),
      ),
      body: Column(
        children: [
          _buildTimeFrameSelector(),
          _buildPriceInfo(),
          Expanded(
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    return Wrap(
      spacing: 8,
      children: CommodityPricesEntity.timeFrames.map((timeFrame) {
        return ChoiceChip(
          label: Text(CommodityPricesEntity.getTimeFrameLabel(timeFrame)),
          selected: _selectedTimeFrame == timeFrame,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedTimeFrame = timeFrame;
                _chartKey = UniqueKey(); // 차트 키를 변경하여 강제로 재생성
              });
            }
          },
        );
      }).toList(),
    );
  }

  String _getFormattedDate(DateTime date, String timeFrame) {
    switch (timeFrame) {
      case '5d':
      case '30d':
        return DateFormat('MM/dd').format(date);
      case '6m':
      case '1y':
        return DateFormat('yy/MM').format(date);
      case '5y':
      case '20y':
        return DateFormat('yyyy').format(date);
      default:
        return DateFormat('MM/dd').format(date);
    }
  }

  Widget _buildChart() {
    final pricePoints = widget.metalData.timeframes[_selectedTimeFrame] ?? [];
    if (pricePoints.isEmpty) {
      return Center(child: Text('No data available for the selected time frame'));
    }

    final convertedPrices = pricePoints
        .map((point) => FlSpot(
              DateTime.parse(point.date).millisecondsSinceEpoch.toDouble(),
              UnitConversion.convertPrice(point.price, 'oz', widget.unit),
            ))
        .toList();

    final minX = convertedPrices.first.x;
    final maxX = convertedPrices.last.x;
    final minY = convertedPrices.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final maxY = convertedPrices.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final yMargin = (maxY - minY) * 0.1;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: LineChart(
        key: _chartKey,
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (maxX - minX) / 3,
                getTitlesWidget: (value, meta) {
                  if (meta.min == value || meta.max == value) return SizedBox.shrink();
                  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getFormattedDate(date, _selectedTimeFrame),
                      style: TextStyle(
                        color: Color(0xff68737d),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: (maxY - minY) / 4,
                getTitlesWidget: (value, meta) {
                  if (meta.min == value || meta.max == value) return SizedBox.shrink();
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          minX: minX,
          maxX: maxX,
          minY: minY - yMargin,
          maxY: maxY + yMargin,
          lineBarsData: [
            LineChartBarData(
              spots: convertedPrices,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
        ),
        duration: Duration.zero,
      ),
    );
  }

  Widget _buildPriceInfo() {
    final pricePoints = widget.metalData.timeframes[_selectedTimeFrame] ?? [];
    if (pricePoints.isEmpty) {
      return SizedBox.shrink();
    }

    final latestPrice = UnitConversion.convertPrice(pricePoints.last.price, 'oz', widget.unit);
    final earliestPrice = UnitConversion.convertPrice(pricePoints.first.price, 'oz', widget.unit);
    final priceChange = latestPrice - earliestPrice;
    final priceChangePercentage = (priceChange / earliestPrice) * 100;

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(62, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Latest: ${latestPrice.toStringAsFixed(2)} ${widget.currency}/${widget.unit}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${priceChange >= 0 ? '+' : ''}${priceChange.toStringAsFixed(2)} (${priceChangePercentage.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: priceChange >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
