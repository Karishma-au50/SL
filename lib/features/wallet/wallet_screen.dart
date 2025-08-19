import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/shared/typography.dart';
import 'package:sl/widgets/toast/my_toast.dart';

import '../../model/user_detail_model.dart';
import '../../model/user_model.dart';
import '../../model/wallet_history_model.dart';
import '../../routes/app_routes.dart';
import '../../shared/services/common_service.dart';
import '../../shared/services/storage_service.dart';
import '../home/controller/dashboard_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  UserDetailModel? userDetails;
  late final UserModel user;
  WalletHistoryModel? walletHistory;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    user = StorageService.instance.getUserId() ?? UserModel();
    _loadWalletHistory();
  }

  _loadUserDetails() async {
    // Load user details if user ID exists
    if (user.id?.isNotEmpty == true) {
      final details = await CommonService.to.getUserDetails();
      if (mounted) {
        setState(() {
          userDetails = details;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadWalletHistory() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await dashboardController.getWalletHistory();

      if (response != null) {
        setState(() {
          walletHistory = response;
          isLoading = false;
        });
      } else {
        setState(() {
          walletHistory = WalletHistoryModel(data: []);
          errorMessage = 'No wallet history found';
          isLoading = false;
        });
      }
      _loadUserDetails();
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
        elevation: 0,
        title: Text(
          "Wallet",
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshWalletHistory,
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                _buildBalanceCard(),
                const SizedBox(height: 20),
                // Winnings Card
                _buildWinningsCard(),
                const SizedBox(height: 20),
                // My Transactions Header
                _buildTransactionHeader(),
                const SizedBox(height: 10),
                // Transactions List
                _buildTransactionsList(),
              ],
            ),
          ),
        ),
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
            child: _buildSummaryCard(
              'Pending',
              pendingCount,
              pendingAmt,
              Colors.orange,
              Icons.pending,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Completed',
              completedCount,
              completedAmt,
              Colors.green,
              Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    String amount,
    Color color,
    IconData icon,
  ) {
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
              Text(title, style: AppTypography.labelSmall(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text(count, style: AppTypography.heading5(color: Colors.white)),
          Text(amount, style: AppTypography.labelMedium(color: color)),
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
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshWalletHistory,
              child: const Text('Retry'),
            ),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshWalletHistory,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: walletHistory!.data.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildHistoryCard(walletHistory!.data[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(WithdrawalRequest request) {
    final safeId = request.id.length > 8
        ? request.id.substring(request.id.length - 8)
        : request.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                    decoration: BoxDecoration(
                      color: request.statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      request.statusIcon,
                      color: request.statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.formattedAmount,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        request.timeSinceCreated,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: request.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  request.statusDisplayText,
                  style: TextStyle(
                    color: request.statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bank Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      request.accountDetails.displayBankInfo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  request.accountDetails.accountHolderName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Request ID: $safeId',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontFamily: 'monospace',
                ),
              ),
              if (request.isCompleted && request.processedBy != null)
                Text(
                  'By: ${request.processedBy!.fullName}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    // Calculate total balance from wallet history
    final totalBalance = walletHistory?.totalCompletedAmount ?? 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Colors.blue.shade900,
        image: DecorationImage(
          image: AssetImage("assets/images/walletBg.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Available Balance (1 Point = ₹1)",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "₹${userDetails?.availablePoints.toStringAsFixed(2) ?? '0.00'}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await context.push(AppRoutes.withdrawPoints);

              _loadUserDetails();
            },
            child: const Text(
              "Get it Now Withdraw",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinningsCard() {
    // Calculate winnings from approved and completed amounts
    final totalWinnings =
        (walletHistory?.totalApprovedAmount ?? 0.0) +
        (walletHistory?.totalCompletedAmount ?? 0.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(Icons.star, color: Colors.orange),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Winning",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Approved + Completed Points",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text(
            totalWinnings.toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "My Transactions",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the wallet history screen
            context.push(AppRoutes.walletHistory, extra: walletHistory);
          },
          child: Text(
            "View All",
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshWalletHistory,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (walletHistory == null || walletHistory!.data.isEmpty) {
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

    return Column(
      children: walletHistory!.data.map((request) {
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
        );
      }).toList(),
    );
  }
}
