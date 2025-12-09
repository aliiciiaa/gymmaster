import 'package:flutter/material.dart';

class AthleteCard extends StatelessWidget {
  final String name;
  final String subscription;
  final String expires;
  final String status;
  final String imageUrl;

  const AthleteCard({
    super.key,
    required this.name,
    required this.subscription,
    required this.expires,
    required this.status,
    required this.imageUrl,
  });

  Color getStatusColor() {
    if (status.toLowerCase().contains("active")) return Colors.black;
    if (status.toLowerCase().contains("expiring")) return Colors.orange;
    if (status.toLowerCase().contains("expired")) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl.replaceAll("localhost", "192.168.1.66"))
                : null,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subscription,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 2),
                Text("Expires: $expires",
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                  color: getStatusColor(), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
