import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sl/widgets/toast/my_toast.dart';

import '../../model/wallet_history_model.dart';
import '../home/controller/dashboard_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final DashboardController dashboardController = Get.find<DashboardController>();

  WalletHistoryModel? walletHistory;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWalletHistory();
  }

  Future<void> _loadWalletHistory() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await dashboardController.getWalletHistory();

      if (response != null && response.isNotEmpty) {
        // If the controller returns List<WalletHistoryModel>, combine them
        List<WithdrawalRequest> allRequests = [];
        for (var model in response) {
          allRequests.addAll(model.data);
        }
        
        setState(() {
          walletHistory = WalletHistoryModel(data: allRequests);
          isLoading = false;
        });
      } else {
        setState(() {
          walletHistory = WalletHistoryModel(data: []);
          errorMessage = 'No wallet history found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
      MyToasts.toastError('Failed to load wallet history: ${e.toString()}');
    }
  }

  Future<void> _refreshWalletHistory() async {
    await _loadWalletHistory();
  }

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
          'Wallet',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshWalletHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          if (walletHistory != null) _buildSummaryCards(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: _buildHistoryContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final pendingCount = walletHistory!.pendingRequests.length.toString();
    final completedCount = walletHistory!.completedRequests.length.toString();
    final pendingAmt = '₹${walletHistory!.totalPendingAmount}';
    final completedAmt = '₹${walletHistory!.totalCompletedAmount}';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard('Pending', pendingCount, pendingAmt, Colors.orange, Icons.pending),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard('Completed', completedCount, completedAmt, Colors.green, Icons.check_circle),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(amount, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildHistoryContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(errorMessage!, style: TextStyle(color: Colors.grey[600], fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refreshWalletHistory, child: const Text('Retry')),
          ],
        ),
      );
    }

    // ✅ Proper empty-state check restored
    if (walletHistory == null || walletHistory!.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No wallet history found',
                style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('Your withdrawal history will appear here',
                style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          ],
        ),
      );
    }

    // ✅ List content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Transaction History (${walletHistory!.data.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshWalletHistory,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: walletHistory!.data.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildHistoryCard(walletHistory!.data[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(WithdrawalRequest request) {
    final safeId = request.id.length > 8 ? request.id.substring(request.id.length - 8) : request.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: request.statusColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(request.statusIcon, color: request.statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.formattedAmount,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(request.timeSinceCreated, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: request.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(request.statusDisplayText,
                    style: TextStyle(color: request.statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bank Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(request.accountDetails.displayBankInfo,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(request.accountDetails.accountHolderName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Request ID: $safeId',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500], fontFamily: 'monospace')),
              if (request.isCompleted && request.processedBy != null)
                Text('By: ${request.processedBy!.fullName}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
