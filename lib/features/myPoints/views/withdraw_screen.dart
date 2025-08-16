import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sl/features/myPoints/controller/redeem_points_controller.dart';
import 'package:sl/model/withdrawal_model.dart';
import 'package:sl/routes/app_routes.dart';
import 'package:sl/shared/services/common_service.dart';
import 'package:sl/widgets/buttons/my_button.dart';
import 'package:sl/widgets/inputs/my_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '500',
  );
  late double availableBalance = 0;
  AccountDetails? _selectedAccountDetails;
  final OfferController _offerController = Get.put(OfferController());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableBalance();
  }

  void _fetchAvailableBalance({bool isRefresh = false}) async {
    CommonService.to.getUserDetails(forceRefresh: isRefresh).then((details) {
      setState(() {
        availableBalance = details.availablePoints;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        title: const Text(
          'Withdraw My Plus Points',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Balance Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            
            decoration: BoxDecoration(
              image: DecorationImage(image: Image.asset("assets/images/amountBg.png").image, fit: BoxFit.contain),
              // gradient: const LinearGradient(
              //   colors: [Color(0xFFB745FC), Color(0xFF8E1DC3)],
              // ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // const Icon(Icons.card_giftcard, color: Colors.white, size: 36),
                const SizedBox(width: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Available Balance',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      currencyFormat.format(availableBalance),
                      style: const TextStyle(
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    // Withdraw Amount Input
                    MyTextField(
                      controller: _amountController,
                      labelText: 'Enter amount',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: "₹500",
                      hindStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Min ₹200 & max ₹50,000 allowed per day',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bank Info
                    Text(
                      'Send Winnings to',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Use Bank Transfer when you withdraw more than your point amount',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    SizedBox(height: 18),
                    GestureDetector(
                      onTap: () async {
                        // Navigate to bank details form and get result
                        final result = await context.push<AccountDetails>(
                          AppRoutes.bankDetailsForm,
                          extra: _selectedAccountDetails,
                        );

                        if (result != null) {
                          setState(() {
                            _selectedAccountDetails = result;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedAccountDetails != null
                              ? Colors.green.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedAccountDetails != null
                                ? Colors.green.shade300
                                : Colors.grey.shade300,
                            width: _selectedAccountDetails != null ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedAccountDetails != null
                                  ? Icons.account_balance
                                  : Icons.add_card,
                              color: _selectedAccountDetails != null
                                  ? Colors.green.shade600
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedAccountDetails?.bankName ??
                                        'Add Bank Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: _selectedAccountDetails != null
                                          ? Colors.green.shade700
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (_selectedAccountDetails != null) ...[
                                    Text(
                                      _selectedAccountDetails!
                                          .accountHolderName,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'A/C: **** **** ${_selectedAccountDetails!.accountNumber.substring(_selectedAccountDetails!.accountNumber.length - 4)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'IFSC: ${_selectedAccountDetails!.ifscCode}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      'Tap to add your bank account details',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              _selectedAccountDetails != null
                                  ? Icons.edit
                                  : Icons.chevron_right,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Withdraw Button
                    MyButton(
                      text: _isLoading ? "Processing..." : "Withdraw Now",
                      color: _selectedAccountDetails != null && !_isLoading
                          ? const Color(0xFF001519)
                          : Colors.grey,
                      onPressed: _selectedAccountDetails != null && !_isLoading
                          ? () async {
                              _handleWithdraw();
                            }
                          : () async {},
                    ),
                    if (_selectedAccountDetails == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Please add bank details to proceed',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleWithdraw() async {
    if (_selectedAccountDetails == null) {
      _showError('Please add bank details first');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount < 1) {
      _showError('Minimum withdrawal is ₹1');
      return;
    } else if (amount > availableBalance) {
      _showError('Insufficient balance');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final withdrawalRequest = WithdrawalRequest(
        pointsRequested: amount,
        accountDetails: _selectedAccountDetails!,
      );

      final success = await _offerController.submitWithdrawal(
        withdrawalRequest,
      );

      if (success && mounted) {
        // Show success bottom sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (_) => WithdrawalSuccessBottomSheet(amount: amount),
        );

        _fetchAvailableBalance(isRefresh: true);
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to process withdrawal: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }
}

class WithdrawalSuccessBottomSheet extends StatelessWidget {
  final double amount;

  const WithdrawalSuccessBottomSheet({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 60, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Withdrawal Request Sent!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Your request for the withdrawal of amount ₹${amount.toStringAsFixed(0)} has been sent successfully.',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          MyButton(
            text: 'Okay, Got it!',
            color: Color(0xFF001519),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
