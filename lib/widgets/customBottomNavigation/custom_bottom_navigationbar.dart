import 'package:flutter/material.dart';

import '../../shared/app_colors.dart';


class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: [
          _buildBottomNavigationBarItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.store_rounded,
            label: 'Stores',
            index: 1,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.photo_album_outlined,
            label: 'Feeds',
            index: 2,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Wallet',
            index: 3,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.celebration_rounded,
            label: 'Offers',
            index: 4,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.qr_code,
            label: 'QR',
            index: 5,
          ),
        ],
        selectedItemColor: AppColors.kcPrimaryColor,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        elevation: 0,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = widget.currentIndex == index;
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          if (isSelected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                color: AppColors.kcPrimaryColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Icon(
              icon,
              size: 27,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
