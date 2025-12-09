import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/dashboard_card.dart';
import '../widgets/activity_item.dart';
import '../widgets/chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ---------------------
  // VARIABLES POUR LA BDD
  // ---------------------
  int totalMembers = 0;
  int activeSubs = 0;
  double incomeToday = 0;
  double expensesToday = 0;
  List<dynamic> recentActivities = [];

  // 🔥 Nouveau : données du graphe
  List<dynamic> weeklyChart = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  // ---------------------
  // 🔥 FETCH PHP
  // ---------------------
  Future<void> fetchDashboardData() async {
    try {
      final url = Uri.parse("http://localhost/gymapi/dashboard.php");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          totalMembers = int.tryParse(data["total_members"].toString()) ?? 0;
          activeSubs = int.tryParse(data["active_subs"].toString()) ?? 0;
          incomeToday = double.tryParse(data["income_today"].toString()) ?? 0.0;
          expensesToday = double.tryParse(data["expenses_today"].toString()) ?? 0.0;

          recentActivities = data["recent_activities"] ?? [];

          // 🔥 Nouveau : graphique
          weeklyChart = data["weekly_chart"] ?? [];

          loading = false;
        });
      } else {
        print("Erreur serveur ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GymMaster',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Owner Dashboard',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // -------------------------
                    // 🔥 DASHBOARD CARDS (DYNAMIQUE)
                    // -------------------------
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        DashboardCard(
                          icon: Icons.people,
                          color: Colors.red,
                          title: 'Total Members',
                          value: totalMembers.toString(),
                        ),
                        DashboardCard(
                          icon: Icons.favorite,
                          color: Colors.pink,
                          title: 'Active Subs',
                          value: activeSubs.toString(),
                        ),
                        DashboardCard(
                          icon: Icons.attach_money,
                          color: Colors.green,
                          title: "Today's Income",
                          value: "${incomeToday.toStringAsFixed(0)} DA",
                        ),
                        DashboardCard(
                          icon: Icons.money_off,
                          color: Colors.orange,
                          title: "Today's Expenses",
                          value: "${expensesToday.toStringAsFixed(0)} DA",
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // -------------------------
                    // 🔥 CHART : maintenant dynamique !
                    // -------------------------
                    const Text(
                      'Weekly Performance',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 18),
                    SizedBox(
                      height: 220,
                      child: ChartWidget(data: weeklyChart),
                    ),

                    const SizedBox(height: 20),

                    // -------------------------
                    // 🔥 ACTIVITÉS RÉCENTES (PHP)
                    // -------------------------
                    const Text(
                      'Recent Activities',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    ...recentActivities.map((item) {
                      return Column(
                        children: [
                          ActivityItem(
                            name: item["name"],
                            action: item["action"],
                            time: item["time"],
                            status: "New",
                            imageAsset: 'assets/images/user1.png',
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
