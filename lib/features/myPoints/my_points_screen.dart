import 'package:flutter/material.dart';

class MyPointsScreen extends StatefulWidget {
  const MyPointsScreen({super.key});

  @override
  State<MyPointsScreen> createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends State<MyPointsScreen> {
  bool isOtherPointsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
      backgroundColor: const Color(0xFF001519),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Points',
          style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold  ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Points Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB745FC), Color(0xFF8E1DC3)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard, color: Colors.white, size: 36),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Balance Points',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Last Updated
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Row(
              children: const [
                Icon(Icons.update, color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text(
                  'Last Updated 17 May 2025',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
       

          

          // List of Points
          Expanded(
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                      Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _buildToggleButton('Scanned Points', !isOtherPointsSelected),
                  _buildToggleButton('Other Points', isOtherPointsSelected),
                ],
              ),
                        ),
              
                  _buildPointsTile(
                    title: 'Welcome Points',
                    dateTime: '17 May 2025 | 10:30 PM',
                    points: 50,
                  ),
                    _buildPointsTile(
                    title: 'Welcome Points',
                    dateTime: '17 May 2025 | 10:30 PM',
                    points: 50,
                  ),  _buildPointsTile(
                    title: 'Welcome Points',
                    dateTime: '17 May 2025 | 10:30 PM',
                    points: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isOtherPointsSelected = (title == 'Other Points');
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF001519) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointsTile({
    required String title,
    required String dateTime,
    required int points,
  }) {
    const textStyle = TextStyle(fontSize: 12);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      leading: const Icon(Icons.event_note, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),
      subtitle: Text(dateTime, style: textStyle),
      trailing: Text(
        '+$points',
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
   
  }
}
