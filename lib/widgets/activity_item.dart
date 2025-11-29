import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final String status;
  final String imageAsset;

  const ActivityItem({
    required this.name,
    required this.action,
    required this.time,
    required this.status,
    required this.imageAsset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage(imageAsset),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(action),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            status,
            style: TextStyle(
              color: status == 'Active' ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
