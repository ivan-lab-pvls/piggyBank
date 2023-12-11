import 'package:collection/collection.dart';
import 'package:financial_piggy_bank/model/transactions_item.dart';
import 'package:financial_piggy_bank/pages/home_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample extends StatefulWidget {
  const PieChartSample({super.key, required this.points});
  final List<TransactionItem> points;

  @override
  State<StatefulWidget> createState() => _PieChartState();
}

class _PieChartState extends State<PieChartSample> {
  int touchedIndex = -1;
  double totalCost = 0.0;
  int savedDateTime = 0;

  @override
  Widget build(BuildContext context) {
    totalCost = 0.0;
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 90,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> list = [];
    ECategoryType savedDateTime = ECategoryType.other;
    var transactions = groupBy(widget.points, (TransactionItem e) => e.type);
    var i = 0;
    transactions.forEach((key, value) {
      for (var transaction in value) {
        final isTouched = i == touchedIndex;
        if (savedDateTime != transaction.type) {
          for (var transaction
              in value.where((element) => element.type == transaction.type)) {
            totalCost = totalCost + transaction.cost!;
          }
          savedDateTime = transaction.type!;
          list.add(PieChartSectionData(
            badgePositionPercentageOffset: 3,
            badgeWidget: isTouched
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF383252),
                        borderRadius: BorderRadius.circular(3)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            transaction.type!.text,
                            style: const TextStyle(
                                color: Color(0xFF928EB0), fontSize: 12),
                          ),
                        ),
                        Text('${totalCost.toString()}\$',
                            style: const TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 12))
                      ],
                    ),
                  )
                : null,
            color: transaction.type == ECategoryType.housing
                ? const Color(0xFF937AFF)
                : transaction.type == ECategoryType.food
                    ? const Color(0xFFFFF27A)
                    : transaction.type == ECategoryType.transport
                        ? const Color(0xFF7AFF88)
                        : transaction.type == ECategoryType.entertaiment
                            ? const Color(0xFFFF7AFA)
                            : const Color(0xFFFF7A7A),
            value: transaction.cost,
            radius: 15.0,
            showTitle: false,
            titleStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ));
        }
        totalCost = 0.0;
        i++;
      }
    });
    for (var transaction in widget.points) {
      // case 1:
      //   return PieChartSectionData(
      //     color: const Color(0xFF7AFF88),
      //     value: 30,
      //     radius: radius,
      //     showTitle: false,
      //     titleStyle: TextStyle(
      //       fontSize: fontSize,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       shadows: shadows,
      //     ),
      //   );
      // case 2:
      //   return PieChartSectionData(
      //     color: const Color(0xFFFF7A7A),
      //     value: 15,
      //     radius: radius,
      //     showTitle: false,
      //     titleStyle: TextStyle(
      //       fontSize: fontSize,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       shadows: shadows,
      //     ),
      //   );
      // case 3:
      //   return PieChartSectionData(
      //     color: const Color(0xFFFF7AFA),
      //     value: 15,
      //     radius: radius,
      //     showTitle: false,
      //     titleStyle: TextStyle(
      //       fontSize: fontSize,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       shadows: shadows,
      //     ),
      //   );
      // case 4:
      //   return PieChartSectionData(
      //     color: const Color(0xFFFFF27A),
      //     value: 15,
      //     showTitle: false,
      //     radius: radius,
      //     titleStyle: TextStyle(
      //       fontSize: fontSize,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       shadows: shadows,
      //     ),
      //   );
      // default:
      //   throw Error();
    }
    return list;
  }
}
