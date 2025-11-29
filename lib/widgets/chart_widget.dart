import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 35),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value >= 0 && value < days.length) {
                  return Text(days[value.toInt()]);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(0, 2200),
              FlSpot(1, 3100),
              FlSpot(2, 2900),
              FlSpot(3, 3400),
              FlSpot(4, 4200),
              FlSpot(5, 5800),
              FlSpot(6, 5000),
            ],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.grey,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(0, 1400),
              FlSpot(1, 1800),
              FlSpot(2, 1600),
              FlSpot(3, 1900),
              FlSpot(4, 2300),
              FlSpot(5, 2700),
              FlSpot(6, 2100),
            ],
          ),
        ],
      ),
    );
  }
}
