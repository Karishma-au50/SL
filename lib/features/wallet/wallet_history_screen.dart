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
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your withdrawal history will appear here',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
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
      child: Column(
        children: widget.initialData!.data.map((request) {
          final safeId = request.id.length > 8
              ? request.id.substring(request.id.length - 8)
              : request.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              margin: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                ),
                color: Colors.white,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: request.statusColor.withOpacity(0.1),
                  child: Icon(request.statusIcon, color: request.statusColor),
                ),
                title: Text(
                  request.statusDisplayText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: request.statusColor,
                  ),
                ),
                subtitle: Text(
                  "T ID: $safeId\n${request.timeSinceCreated}",
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  request.formattedAmount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: request.statusColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
