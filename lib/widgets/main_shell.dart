import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navigationItems = [
    {'icon': Icons.home, 'label': 'Home', 'path': '/'},
    {'icon': Icons.local_offer, 'label': 'All Offers', 'path': '/allOffers'},
    {
      'icon': Icons.account_balance_wallet,
      'label': 'Wallet',
      'path': '/wallet',
    },

    {'icon': Icons.help_outline, 'label': 'Help', 'path': '/faq'},
    {'icon': Icons.person, 'label': 'Profile', 'path': '/profile'},
  ];

  void _onItemTapped(int index) {
    final path = _navigationItems[index]['path'] as String;
    context.go(path);
  }

  int _calculateSelectedIndex(String location) {
    for (int i = 0; i < _navigationItems.length; i++) {
      if (location.endsWith(_navigationItems[i]['path'])) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    _selectedIndex = _calculateSelectedIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF001519),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
