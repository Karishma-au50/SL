import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sl/shared/typography.dart';

import '../../model/wallet_history_model.dart';
import '../../widgets/toast/my_toast.dart';
import '../home/controller/dashboard_controller.dart';

class WalletHistoryScreen extends StatefulWidget {
  final WalletHistoryModel? initialData;

  const WalletHistoryScreen({super.key, this.initialData});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Wallet History",
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _buildTransactionsList(),
    );
  }

  Widget _buildTransactionsList() {
    if (widget.initialData == null || widget.initialData!.data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No wallet history found',
                style: AppTypography.bodyMedium(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Your withdrawal history will appear here',
                style: AppTypography.labelSmall(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: widget.initialData!.data.map((request) {
          final safeId = request.id.length > 8
              ? request.id.substring(request.id.length - 8)
              : request.id;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Status, Amount, Time
                  Row(
                    children: [
                      request.stutusWidget,
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.statusDisplayText,
                              style: AppTypography.labelMedium(
                                color: request.statusColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "T ID: $safeId",
                              style: AppTypography.labelSmall(
                                color: Color(0xFF747474),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            request.formattedAmount,
                            style: AppTypography.heading6(
                              color: request.formattedAmountColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/calender.png',
                                height: 10,
                                width: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                request.timeSinceCreated,
                                style: AppTypography.labelSmall(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
