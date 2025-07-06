import 'package:flutter/material.dart';

import '../../../shared/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF001519),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Help',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      "https://i.pinimg.com/736x/4c/53/91/4c5391c2a69855120a204971a728f421.jpg",
                      width: 50,
                      height: 50,

                      fit: BoxFit.cover,
                    ),
                  ),
                  // const CircleAvatar(
                  //   radius: 24,
                  //   backgroundImage: AssetImage('assets/avatar.jpg'),
                  // ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to SLC',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Abhishant Kumar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.wallet_travel_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 16),

            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://i.pinimg.com/736x/6e/f8/07/6ef807006f13aee267a8058b316fb977.jpg',
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top Actions
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        Column(
                          children: [
                            _actionBox(Icons.qr_code_scanner, 'Scan Product'),
                            const SizedBox(height: 10),
                            _actionBox(Icons.chat, 'Chat with us'),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF3F4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.kcPrimaryColor
                                    .withOpacity(0.1),
                                child: Icon(
                                  Icons.card_giftcard,
                                  size: 18,
                                  color: AppColors.kcPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Redeem MY Plus\nPoints',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // More options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _iconCircle('Gift\nTracker', Icons.redeem),
                        _iconCircle('Company\nPolicy', Icons.policy),
                        _iconCircle('SLC\nVideo', Icons.ondemand_video),
                        _iconCircle('About\nus', Icons.info_outline),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Points Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001519),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(
                            children: [
                               const Text(
                            'Total Points (1 Point = ₹1)',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          // const SizedBox(height: 8),
                          const Text(
                            '₹ 22550.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            ],
                          ),
                          Image.asset(
                            'assets/images/boy.png',
                            width: 100,
                            height: 100,
                          ),
                         ],),
                          // const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Get it Now Withdraw'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Redeem List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Redeem Points',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View All',
                            style: TextStyle(color: AppColors.kcPrimaryColor),
                          ),
                        ),
                      ],
                    ),

                    // Redeem List Items
                    _redeemTile('Manisha Sharma', '20 Mar, 2023', '500'),
                    _redeemTile('Manisha Sharma', '20 Mar, 2023', '500'),
                    _redeemTile('Aarti Kumari', '19 Mar, 2023', '1500'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBox(IconData icon, String title) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.kcPrimaryColor.withOpacity(0.1),
            child: Icon(icon, size: 18, color: AppColors.kcPrimaryColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: AppColors.kcPrimaryColor.withOpacity(0.2),
          // width: 1,
        ),
          borderRadius: BorderRadius.circular(45),
      
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 68,
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF3F4), // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(45),
      
          // boxShadow: [BoxShadow(color: const Color(0xFFFDF3F4), blurRadius: 6)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.kcPrimaryColor),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _redeemTile(String name, String date, String points) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.network(
        "https://i.pinimg.com/736x/3c/07/d4/3c07d4d147861c7233aec7c824e34cb5.jpg",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(date, style: const TextStyle(color: Colors.grey)),
      trailing: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'Poppins'),
          children: [
            TextSpan(
              text: '$points ',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            WidgetSpan(
              child: Icon(Icons.arrow_outward, size: 14, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
