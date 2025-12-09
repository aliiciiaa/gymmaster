import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  final List<dynamic> data;

  const ChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Convertir income
    final incomeSpots = data.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        (e.value["income"] as num).toDouble(),
      );
    }).toList();

    // Convertir expenses
    final expenseSpots = data.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        (e.value["expense"] as num).toDouble(),
      );
    }).toList();

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
                const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
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
          // Income (ROUGE)
          LineChartBarData(
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            spots: incomeSpots,
          ),
          // Expense (BLEU)
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            spots: expenseSpots,
          ),
        ],
      ),
    );
  }
}
