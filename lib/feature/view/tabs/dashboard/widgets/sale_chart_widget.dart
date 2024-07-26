part of '../dashboard_view.dart';

class _SaleChartWidget extends StatefulWidget {
  const _SaleChartWidget({super.key});
  @override
  State<_SaleChartWidget> createState() => _SaleChartWidgetState();
}

class _SaleChartWidgetState extends State<_SaleChartWidget> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.indigo,
  ];

  ValueNotifier<bool> showAvg = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: ValueListenableBuilder(
            valueListenable: showAvg,
            builder: (context, value, _) {
              return LineChart(
                duration: Durations.long1,
                value ? _avgData() : _mainData(),
              );
            },
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              showAvg.value = !showAvg.value;
            },
            child: ValueListenableBuilder(
              valueListenable: showAvg,
              builder: (context, value, _) {
                return Text(
                  'avg',
                  style: TextStyle(
                    fontSize: 12,
                    color: value ? Colors.white.withOpacity(0.5) : Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
      case 5:
        text = const Text('JUN', style: style);
      case 8:
        text = const Text('SEP', style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    //  if(value % 1000 == 0){
    //   text = '${value ~/ 1000}K';
    // }
    switch (value.toInt()) {
      case 1000:
        text = '1K';
      case 500:
        text = '500';
      case 100:
        text = '100';
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: FlGridData(
        verticalInterval: 1,
        horizontalInterval: 100,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      baselineX: 0,
      baselineY: 0,
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      maxY: context.read<SalesCubit>().highestSale() < 1000 ? 1000 : context.read<SalesCubit>().highestSale(),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: [
            for (var i = 0; i < 12; i++)
              FlSpot(
                i.toDouble(),
                context.read<SalesCubit>().getTotalSoldMeterByMonth(i),
              ),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        verticalInterval: 1,
        horizontalInterval: 50,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: _bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: (context.read<SalesCubit>().getAverageSales() ?? 50) * 2,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (var i = 0; i < 12; i++)
              FlSpot(
                i.toDouble(),
                context.read<SalesCubit>().getAverageSales() ?? 0,
              ),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
