import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- TOP STATS ----
          Row(
            children: [
              Expanded(child: _statCard("Total Products", "8", Icons.shop)),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  "Low Stock",
                  "2",
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _statCard(
            "Total Sales This Month",
            "265 100 DA",
            Icons.trending_up,
            color: Colors.green,
          ),

          const SizedBox(height: 25),
          const Text(
            "Sales by Category",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ---- PIE CHART ----
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.red,
                    value: 60,
                    title: "Supplements 60%",
                    radius: 60,
                    titleStyle:
                        const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.grey.shade800,
                    value: 25,
                    title: "Accessories 25%",
                    radius: 55,
                    titleStyle:
                        const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.grey.shade400,
                    value: 15,
                    title: "Equipment 15%",
                    radius: 50,
                    titleStyle:
                        const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ---- PRODUCT LIST ----
          const Text(
            "Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _productCard(
            name: "Whey Protein 2kg",
            category: "Supplements",
            stock: 15,
            price: "5 800 DA",
          ),
          _productCard(
            name: "Creatine Monohydrate",
            category: "Supplements",
            stock: 8,
            price: "3 200 DA",
          ),
          _productCard(
            name: "Pre-Workout Energy",
            category: "Supplements",
            stock: 3,
            price: "4 000 DA",
            lowStock: true,
          ),
          _productCard(
            name: "Gym Water Bottle",
            category: "Accessories",
            stock: 12,
            price: "1 200 DA",
          ),
          _productCard(
            name: "Resistance Bands Set",
            category: "Equipment",
            stock: 12,
            price: "2 400 DA",
          ),
          _productCard(
            name: "Protein Bars (Box)",
            category: "Snacks",
            stock: 3,
            price: "3 500 DA",
            lowStock: true,
          ),
          _productCard(
            name: "Gym Towel",
            category: "Accessories",
            stock: 18,
            price: "900 DA",
          ),
          _productCard(
            name: "Workout Gloves",
            category: "Accessories",
            stock: 7,
            price: "1 600 DA",
          ),
        ],
      ),

      // ---- ADD BUTTON ----
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.red700,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  /// ---- STAT CARD ----
  Widget _statCard(String title, String value, IconData icon,
      {Color color = Colors.blue}) {
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
                        fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 20, color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  /// ---- PRODUCT CARD ----
  Widget _productCard({
    required String name,
    required String category,
    required int stock,
    required String price,
    bool lowStock = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- LEFT SIDE (Name + Category + Stock + Price) ----
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Stock: $stock",
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // ---- RIGHT SIDE (Badge + Sell Button) ----
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                  decoration: BoxDecoration(
                    color: lowStock ? Colors.red.shade600 : Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lowStock ? "Low Stock" : "In Stock",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    side: const BorderSide(
                      color: AppColors.red700,
                      width: 1.3,
                    ),
                  ),
                  child: const Text(
                    "Sell",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
