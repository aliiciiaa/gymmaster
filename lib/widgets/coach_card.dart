// widgets/coach_card.dart
import 'package:flutter/material.dart';

class CoachCard extends StatelessWidget {
  final String name;
  final String role;
  final String? phone;
  final String? hireDate;
  final int? salary;
  final String? imageUrl;
  final int? attendanceRate;
  final int? yearsService;

  const CoachCard({
    super.key,
    required this.name,
    required this.role,
    this.phone,
    this.hireDate,
    this.salary,
    this.imageUrl,
    this.attendanceRate,
    this.yearsService,
  });

  Color getAttendanceColor() {
    if (attendanceRate == null) return Colors.grey;
    if (attendanceRate! >= 90) return Colors.green;
    if (attendanceRate! >= 80) return Colors.orange;
    return Colors.red;
  }

  String formatSalary() {
    if (salary == null) return 'N/A';
    return '${(salary! / 1000).toStringAsFixed(0)}K DA';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // AVATAR
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: ClipOval(
              child: _buildAvatar(),
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                if (phone != null && phone!.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        phone!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (yearsService != null)
                  Row(
                    children: [
                      Icon(
                        Icons.work,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$yearsService years",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          // STATS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: getAttendanceColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: getAttendanceColor(), width: 1),
                ),
                child: Text(
                  "${attendanceRate ?? 'N/A'}%",
                  style: TextStyle(
                    color: getAttendanceColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatSalary(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : "?",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    try {
      String url = imageUrl!.trim();
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } catch (e) {
      return Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : "?",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }
  }
}