import 'package:flutter/material.dart';
import 'package:sl/shared/typography.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      "title": "25% Discount 🎉",
      "description":
          "Congratulations! Use discount and Scan SL Point and Chemicide 20 LTR bottles 800 Plus Points in added wallet.",
      "time": "3 hours ago",
    },
    {
      "title": "25% Discount 🎉",
      "description":
          "Congratulations! Use discount and Scan SL Point and Chemicide 20 LTR bottles 800 Plus Points in added wallet.",
      "time": "5 hours ago",
    },
    {
      "title": "25% Discount 🎉",
      "description":
          "Congratulations! Use discount and Scan SL Point and Chemicide 20 LTR bottles 800 Plus Points in added wallet.",
      "time": "8 hours ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B23), // dark green
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.pink.shade50,
                  child: const Icon(
                    Icons.local_offer,
                    color: Colors.pink,
                    size: 28,
                  ),
                ),
                title: Text(
                  notification["title"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      notification["description"]!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification["time"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
