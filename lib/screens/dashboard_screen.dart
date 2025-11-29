import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/activity_item.dart';
import '../widgets/chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
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
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  DashboardCard(
                    icon: Icons.people,
                    color: Colors.red,
                    title: 'Total Members',
                    value: '284',
                  ),
                  DashboardCard(
                    icon: Icons.favorite,
                    color: Colors.pink,
                    title: 'Active Subs',
                    value: '267',
                  ),
                  DashboardCard(
                    icon: Icons.attach_money,
                    color: Colors.green,
                    title: "Today's Income",
                    value: '12,500 DA',
                  ),
                  DashboardCard(
                    icon: Icons.money_off,
                    color: Colors.orange,
                    title: "Today's Expenses",
                    value: '3,200 DA',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Weekly Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              const SizedBox(height: 220, child: ChartWidget()),
              const SizedBox(height: 20),
              const Text(
                'Recent Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const ActivityItem(
                name: 'Sarah Johnson',
                action: 'Checked in',
                time: '2 minutes ago',
                status: 'Active',
                imageAsset: 'assets/images/user1.png',
              ),
              const Divider(),
              const ActivityItem(
                name: 'Mike Davis',
                action: 'Subscription renewed',
                time: '15 minutes ago',
                status: 'Payment',
                imageAsset: 'assets/images/user2.png',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
