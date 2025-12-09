import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  bool loading = true;

  int income = 0;
  int expenses = 0;
  int profit = 0;

  List<Map<String, dynamic>> monthly = [];
  List<Map<String, dynamic>> transactions = [];

  String filter = "all"; // "all", "income", "expense", "summary"

  @override
  void initState() {
    super.initState();
    loadFinance();
  }

  Future<void> loadFinance() async {
    var url = Uri.parse("http://localhost/gymapi/get_finance.php");
    var res = await http.get(url);

    List<String> lines = res.body.split("\n");

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // TOTALS
      if (line.startsWith("INCOME=")) {
        income = int.parse(line.split("=")[1]);
      } 
      else if (line.startsWith("EXPENSES=")) {
        expenses = int.parse(line.split("=")[1]);
      } 
      else if (line.startsWith("PROFIT=")) {
        profit = int.parse(line.split("=")[1]);
      } 

      // MONTHLY
      else if (line.startsWith("MONTH=")) {
        var parts = line.split(";");
        monthly.add({
          "month": parts[0].split("=")[1],
          "income": double.parse(parts[1].split("=")[1]),
          "expenses": double.parse(parts[2].split("=")[1]),
        });
      }

      // TRANSACTIONS
      else if (line.startsWith("TRANSACTION=")) {
  var parts = line.replaceFirst("TRANSACTION=", "").split(";");

  if (parts.length < 3) continue; // 3 éléments, pas 4 !

  String type = parts[0].trim();   // Income ou Expense
  String category = parts[1].trim();
  double amount = double.tryParse(parts[2].trim()) ?? 0;

  transactions.add({
    "category": category,
    "amount": amount,
    "isIncome": type.toLowerCase() == "income",
  });
}


    }

    setState(() {
      loading = false;
    });
  }

  double currentMonthIncome() => monthly.isEmpty ? 0 : monthly.last["income"];
  double currentMonthExpenses() => monthly.isEmpty ? 0 : monthly.last["expenses"];
  double currentMonthProfit() => currentMonthIncome() - currentMonthExpenses();

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Filtrage transactions
    List<Map<String, dynamic>> displayedTransactions;
if (filter == "income") {
  displayedTransactions = transactions.where((t) => t["isIncome"]).toList();
} else if (filter == "expense") {
  displayedTransactions = transactions.where((t) => !t["isIncome"]).toList();
} else {
  displayedTransactions = transactions; // "all" ou autre
}


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Finances"), backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard("Total Income", "$income DA", Icons.trending_up, Colors.green),
            const SizedBox(height: 12),
            _buildSummaryCard("Total Expenses", "$expenses DA", Icons.trending_down, Colors.red),
            const SizedBox(height: 12),
            _buildSummaryCard("Net Profit", "$profit DA", Icons.attach_money, Colors.blue),
            const SizedBox(height: 20),

            const Text("Monthly Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= monthly.length) return Container();
                          return Text(monthly[index]["month"]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(monthly.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barsSpace: 6,
                      barRods: [
                        BarChartRodData(toY: monthly[i]["expenses"], width: 16, color: Colors.red),
                        BarChartRodData(toY: monthly[i]["income"], width: 16, color: Colors.green),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Transactions Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton(
      onPressed: () => setState(() => filter = "all"),
      style: ElevatedButton.styleFrom(
          backgroundColor: filter == "all" ? Colors.grey.shade700 : Colors.grey),
      child: const Text("All"),
    ),
    ElevatedButton(
      onPressed: () => setState(() => filter = "income"),
      style: ElevatedButton.styleFrom(
          backgroundColor: filter == "income" ? Colors.green : Colors.grey),
      child: const Text("Income"),
    ),
    ElevatedButton(
      onPressed: () => setState(() => filter = "expense"),
      style: ElevatedButton.styleFrom(
          backgroundColor: filter == "expense" ? Colors.red : Colors.grey),
      child: const Text("Expenses"),
    ),
    ElevatedButton(
      onPressed: () => setState(() => filter = "summary"),
      style: ElevatedButton.styleFrom(
          backgroundColor: filter == "summary" ? Colors.blue : Colors.grey),
      child: const Text("Summary"),
    ),
  ],
),

                    const SizedBox(height: 12),

                    if (filter == "summary")
                      Column(
                        children: [
                          _buildSummaryCard("Income This Month", "${currentMonthIncome()} DA", Icons.trending_up, Colors.green),
                          const SizedBox(height: 12),
                          _buildSummaryCard("Expenses This Month", "${currentMonthExpenses()} DA", Icons.trending_down, Colors.red),
                          const SizedBox(height: 12),
                          _buildSummaryCard("Profit This Month", "${currentMonthProfit()} DA", Icons.attach_money, Colors.blue),
                        ],
                      )
                    else
                      Column(
                        children: [
                          for (var t in displayedTransactions)
                            _transaction(
                              t["category"].toLowerCase() == "salary" ? "Salary (Expense)" : t["category"],
                              "${t["amount"]} DA",
                              t["isIncome"],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
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
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(amount, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _transaction(String title, String amount, bool isIncome) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text((isIncome ? "+ " : "- ") + amount,
            style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
