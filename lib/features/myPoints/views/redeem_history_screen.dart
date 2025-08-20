import 'package:flutter/material.dart';
import 'package:sl/model/user_redeem_history_model.dart';
import 'package:sl/shared/constant/app_colors.dart';
import 'package:sl/shared/utils/date_formators.dart';
import 'package:sl/widgets/network_image_view.dart';

import '../../../shared/typography.dart';

class RedeemHistoryScreen extends StatelessWidget {
  const RedeemHistoryScreen({super.key, required this.redeemHistory});

  final UserRedeemHistoryModel redeemHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519), // dark green
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Redeem History",
          style: AppTypography.heading6(color: Colors.white),
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
          padding: EdgeInsets.only(top: 12, bottom: 12),
          itemBuilder: (context, index) {
            final redemption = redeemHistory.recentRedemptions![index];
            final points = redemption.pointsEarned?.toString() ?? '0';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12),
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFF3F3F3)),
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  CircleAvatar(
                    // radius: 50,
                    backgroundColor: const Color(0xFFF3F2F2),
                    child: redemption.offerId.productId?.images.isEmpty ?? true
                        ? Image.asset(
                            "assets/images/defaultProductLogo.png",
                            height: 25,
                            width: 25,
                            fit: BoxFit.contain,
                          )
                        : NetworkImageView(
                            imgUrl:
                                redemption.offerId.productId?.images.first ??
                                '',
                          ),
                  ),

                  const SizedBox(width: 12),

                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          redemption.offerId.productId?.title ?? 'Product',
                          style: AppTypography.labelMedium(
                            color: const Color(0xFF1D1F22),
                          ),
                          //  const TextStyle(
                          //   fontSize: 14,
                          //   fontWeight: FontWeight.w500,
                          //   color: Colors.black,
                          // ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          redemption.completedAt.toFormattedString(),
                          style: AppTypography.bodySmall(
                            color: const Color(0xFF747474),
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
                        style: AppTypography.bodyMedium(
                          color: const Color(0xFFFF2424),
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
