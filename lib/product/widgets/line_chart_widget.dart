import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    required this.salesState,
    required this.importerState,
    super.key,
  });
  final SalesState salesState;
  final ImporterState importerState;

  @override
  Widget build(BuildContext context) {
    final salesGradientColors = <Color>[
      const Color(0xFF50E4FF),
      const Color(0xFF2196F3),
    ];
    final purchasesGradientColors = <Color>[
      Color.fromARGB(255, 255, 0, 127),
      Color.fromARGB(255, 76, 0, 38),
    ];
    return LineChart(
        curve: Curves.linear,
        LineChartData(
          gridData: FlGridData(
            horizontalInterval: 200,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 500,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 3000,
          lineBarsData: [
            LineChartBarData(
              spots: salesState.sales?.map((e) {
                    return FlSpot(
                      e.dateTime.month.toDouble(),
                      context.read<SalesCubit>().getTotalSoldMeterByMonth(
                            e.dateTime.month,
                          ),
                    );
                  }).toList() ??
                  [const FlSpot(0, 0)],
              isCurved: true,
              gradient: LinearGradient(
                colors: salesGradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: salesGradientColors.map((color) => color.withOpacity(0.3)).toList(),
                ),
              ),
            ),
            LineChartBarData(
              color: Colors.red,
              spots: importerState.importers?[0].purchases.isNotEmpty ?? false
                  ? importerState.importers![0].purchases.map((e) {
                      return FlSpot(
                        e.purchasedDate.month.toDouble(),
                        context.read<ImporterCubit>().getPurchasesMeterByMonth(e.purchasedDate.month),
                      );
                    }).toList()
                  : [const FlSpot(0, 0)],
              isCurved: true,
              gradient: LinearGradient(
                colors: purchasesGradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: purchasesGradientColors.map((color) => color.withOpacity(0.3)).toList(),
                ),
              ),
            )
          ],
        ));
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 2:
      text = const Text('MAR', style: style);

    case 5:
      text = const Text('HAZ', style: style);

    case 8:
      text = const Text('EYL', style: style);

    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 1000:
      text = const Text(
        '1000 ',
        style: style,
      );
    default:
      text = Text('${value.toInt()}', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

// LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   horizontalInterval: 1,
//                   verticalInterval: 1,
//                   getDrawingHorizontalLine: (value) {
//                     return const FlLine(
//                       color: Colors.green,
//                       strokeWidth: 1,
//                     );
//                   },
//                   getDrawingVerticalLine: (value) {
//                     return const FlLine(
//                       color: Colors.green,
//                       strokeWidth: 1,
//                     );
//                   },
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       interval: 1,
//                       getTitlesWidget: bottomTitleWidgets,
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 1,
//                       getTitlesWidget: leftTitleWidgets,
//                       reservedSize: 42,
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: const Color(0xff37434d)),
//                 ),
//                 minX: 0,
//                 maxX: 11,
//                 minY: 0,
//                 maxY: 6,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 3),
//                       FlSpot(2.6, 2),
//                       FlSpot(4.9, 5),
//                       FlSpot(6.8, 3.1),
//                       FlSpot(8, 4),
//                       FlSpot(9.5, 3),
//                       FlSpot(11, 4),
//                     ],
//                     isCurved: true,
//                     gradient: LinearGradient(
//                       colors: gradientColors,
//                     ),
//                     barWidth: 5,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(
//                       show: false,
//                     ),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
