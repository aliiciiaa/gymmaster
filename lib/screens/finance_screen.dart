import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Finances"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard(
              title: "Total Income",
              amount: "87 500 DA",
              icon: Icons.trending_up,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              title: "Total Expenses",
              amount: "45 200 DA",
              icon: Icons.trending_down,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              title: "Net Profit",
              amount: "42 300 DA",
              icon: Icons.attach_money,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              "Monthly Comparison",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ["Sep", "Oct", "Nov", "Dec", "Jan"];
                          if (value < 0 || value > 4) return Container();
                          return Text(labels[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    _bar(0, income: 35000, expenses: 25000),
                    _bar(1, income: 38000, expenses: 27000),
                    _bar(2, income: 36000, expenses: 24000),
                    _bar(3, income: 58000, expenses: 26000),
                    _bar(4, income: 40000, expenses: 25000),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              "Transactions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            _transaction("Monthly Membership - Sarah Johnson", "5 000 DA"),
            _transaction("Personal Training - Mike Davis", "3 500 DA"),
            _transaction("Monthly Membership - Alex Rodriguez", "5 000 DA"),
            _transaction("Supplement Sale", "1 200 DA"),
            _transaction("New Member Registration", "8 600 DA"),
          ],
        ),
      ),
    );
  }

  /// ---- SUMMARY CARD ----
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(amount,
                    style: TextStyle(
                        fontSize: 20,
                        color: color,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---- BAR CHART BUILDER ----
  BarChartGroupData _bar(int x,
      {required double income, required double expenses}) {
    return BarChartGroupData(
      x: x,
      barsSpace: 6,
      barRods: [
        BarChartRodData(
          toY: expenses,
          width: 16,
          color: Colors.redAccent,
        ),
        BarChartRodData(
          toY: income,
          width: 16,
          color: Colors.grey.shade700,
        ),
      ],
    );
  }

  /// ---- TRANSACTION ITEM ----
  Widget _transaction(String title, String amount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          "+ $amount",
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
