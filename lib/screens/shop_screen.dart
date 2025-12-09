import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'package:http/http.dart' as http;

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // ---- API URL ----
  final String apiUrl = "http://localhost/gymapi/get_shop.php";

  // ---- VARIABLES ----
  int totalProducts = 0;
  int lowStock = 0;
  int totalSales = 0;

  List<Map<String, dynamic>> categorySales = [];
  List<Map<String, dynamic>> products = [];

  bool loading = true;

  // ---------------------------------------------------------
  @override
  void initState() {
    super.initState();
    loadShopData();
  }

  // ---------------------------------------------------------
  Future<void> loadShopData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) return;

      List<String> lines = response.body.split("\n");

      categorySales.clear();
      products.clear();

      for (String line in lines) {
        if (line.startsWith("TOTAL_PRODUCTS=")) {
          totalProducts = int.parse(line.split("=")[1]);
        }

        else if (line.startsWith("LOW_STOCK=")) {
          lowStock = int.parse(line.split("=")[1]);
        }

        else if (line.startsWith("TOTAL_SALES=")) {
          totalSales = int.parse(line.split("=")[1]);
        }

        else if (line.startsWith("CATEGORY=")) {
          var parts = line.replaceFirst("CATEGORY=", "").split(";TOTAL=");
          categorySales.add({
            "category": parts[0],
            "total": int.parse(parts[1])
          });
        }

        else if (line.startsWith("PRODUCT=")) {
          var p = line.replaceFirst("PRODUCT=", "").split(";");
          products.add({
            "name": p[0],
            "category": p[1],
            "stock": int.parse(p[2]),
            "price": int.parse(p[3]),
          });
        }
      }
    } catch (e) {
      print("ERROR SHOP: $e");
    }

    setState(() => loading = false);
  }

  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ---- TOP STATS ----
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Total Products",
                        "$totalProducts",
                        Icons.shop,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        "Low Stock",
                        "$lowStock",
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _statCard(
                  "Total Sales This Month",
                  "$totalSales DA",
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
                      sections: categorySales.map((s) {
                        double totalLocal = categorySales.fold(
                            0, (sum, item) => sum + item["total"]);
                        double percent =
                            (s["total"] / totalLocal) * 100;

                        return PieChartSectionData(
                          color: _getCategoryColor(s["category"]),
                          value: percent,
                          radius: 60,
                          title:
                              "${s["category"]} ${percent.toStringAsFixed(1)}%",
                          titleStyle: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // ---- PRODUCT LIST ----
                ...products.map((p) {
                  return _productCard(
                    name: p["name"],
                    category: p["category"],
                    stock: p["stock"],
                    price: "${p["price"]} DA",
                    lowStock: p["stock"] < 5,
                  );
                }),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.red700,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------------------------------------------------------
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Supplements":
        return Colors.red;
      case "Accessories":
        return Colors.grey.shade800;
      case "Equipment":
        return Colors.grey.shade400;
      default:
        return Colors.blue;
    }
  }

  // ---------------------------------------------------------
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

  // ---------------------------------------------------------
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
            // ---- LEFT ----
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(category,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Text("Stock: $stock", style: const TextStyle(fontSize: 14)),
                Text(price,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
              ],
            ),

            // ---- RIGHT ----
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
                    side:
                        const BorderSide(color: AppColors.red700, width: 1.3),
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
