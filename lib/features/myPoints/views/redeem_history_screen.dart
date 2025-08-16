import 'package:flutter/material.dart';
import 'package:sl/model/user_redeem_history_model.dart';
import 'package:sl/shared/constant/app_colors.dart';
import 'package:sl/shared/utils/date_formators.dart';

class RedeemHistoryScreen extends StatelessWidget {
  const RedeemHistoryScreen({super.key, required this.redeemHistory});

  final UserRedeemHistoryModel redeemHistory;

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
        title: const Text(
          "Wallet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView.builder(
          itemCount: redeemHistory.recentRedemptions.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final redemption = redeemHistory.recentRedemptions![index];
            final points = redemption.pointsEarned?.toString() ?? '0';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  // Icon
                  CircleAvatar(
                    // radius: 50,
                    backgroundColor: AppColors.kcPrimaryColor.withOpacity(0.1),
                    child: Image.asset(
                      "assets/images/defaultProductLogo.png",
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          redemption.redemptionCode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          redemption.completedAt.toFormattedString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Points
                  Row(
                    children: [
                      Text(
                        points,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.north_east, size: 14, color: Colors.red),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
