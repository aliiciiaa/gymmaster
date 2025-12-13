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
    if (status.toLowerCase().contains("active")) return Colors.green;
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
          // AVATAR AVEC GESTION D'ERREUR
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
                  subscription,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Expires: $expires",
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: getStatusColor(), width: 1),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: getStatusColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (imageUrl.isEmpty) {
      return Center(
        child: Icon(
          Icons.person,
          size: 28,
          color: Colors.grey[500],
        ),
      );
    }

    // Nettoyer l'URL
    String url = imageUrl.trim();
    url = url.replaceAll('\r\n', '').replaceAll('\n', '');

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(
            Icons.person,
            size: 28,
            color: Colors.grey[500],
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
  }
}