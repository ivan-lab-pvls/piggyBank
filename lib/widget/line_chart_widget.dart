import 'package:collection/collection.dart';
import 'package:financial_piggy_bank/model/transactions_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<TransactionItem> points;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  double totalCost = 0.0;
  Map<int, List<TransactionItem>> transactionsMap = {};
  bool add = false;
  int savedDateTime = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    transactionsMap =
        groupBy(widget.points, (TransactionItem e) => e.date!.month);
    totalCost = 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        color: const Color(0xFF28233E),
        padding: const EdgeInsets.only(top: 30, bottom: 30),
        child: AspectRatio(
          aspectRatio: 2,
          child: BarChart(
            BarChartData(
              backgroundColor: const Color(0xFF28233E),
              barGroups: _chartGroups(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xFF383252),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFF383252),
                    ),
                  )),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    List<BarChartGroupData> list = [];
    savedDateTime = 0;
    transactionsMap.forEach((key, value) {
      if (savedDateTime != key) {
        for (var transaction
            in value.where((element) => element.date!.month == key)) {
          totalCost = totalCost + transaction.cost!;
        }
        savedDateTime = key;
        list.add(BarChartGroupData(x: savedDateTime, barRods: [
          BarChartRodData(
              toY: totalCost,
              color: Colors.white,
              width: 5,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ))
        ]));

        totalCost = 0.0;
      }
    });
    return list;
    // return widget.points
    //     .map((point) => BarChartGroupData(
    //         x: point.date!.month, barRods: [BarChartRodData(toY: totalCost)]))
    //     .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Jan';
              break;
            case 2:
              text = 'Feb';
              break;
            case 3:
              text = 'Mar';
              break;
            case 4:
              text = 'Apr';
              break;
            case 5:
              text = 'May';
              break;
            case 6:
              text = 'Jun';
              break;
            case 7:
              text = 'Jun';
              break;
            case 8:
              text = 'Aug';
              break;
            case 9:
              text = 'Sep';
              break;
            case 10:
              text = 'Oct';
              break;
            case 11:
              text = 'Nov';
              break;
            case 12:
              text = 'Dec';
              break;
          }

          return Text(
            text,
            style: const TextStyle(color: Color(0xFF64607D)),
          );
        },
      );
}
