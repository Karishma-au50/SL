import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/model/withdrawal_model.dart';
import 'package:sl/shared/typography.dart';
import 'package:sl/widgets/buttons/my_button.dart';
import 'package:sl/widgets/inputs/my_text_field.dart';

class BankDetailForm extends StatefulWidget {
  final AccountDetails? initialData;

  const BankDetailForm({super.key, this.initialData});

  @override
  State<BankDetailForm> createState() => _BankDetailFormState();
}

class _BankDetailFormState extends State<BankDetailForm> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _accountHolderNameController.text = widget.initialData!.accountHolderName;
      _accountNumberController.text = widget.initialData!.accountNumber;
      _bankNameController.text = widget.initialData!.bankName;
      _ifscCodeController.text = widget.initialData!.ifscCode;
      _upiIdController.text = widget.initialData!.upiId;
    }
  }

  @override
  void dispose() {
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _upiIdController.dispose();
    super.dispose();
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
        title: Text(
          'Add Bank Details',
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Bank Account Information',
                        style: AppTypography.bodyBold(
                          color: const Color(0xFF001519),
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        'Please provide your bank account details for withdrawal',
                        style: AppTypography.bodySmall(
                          color: const Color(0xFF888888),
                        ),
                      ),
                      const SizedBox(height: 24),
              
                      // Account Holder Name
                      MyTextField(
                        controller: _accountHolderNameController,
                        labelText: 'Account Holder Name',
                        hintText: 'Enter account holder name',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter account holder name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
              
                      // Account Number
                      MyTextField(
                        controller: _accountNumberController,
                        labelText: 'Account Number',
                        hintText: 'Enter account number',
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter account number';
                          }
                          if (value.length < 9 || value.length > 18) {
                            return 'Account number must be between 9-18 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
              
                      // Bank Name
                      MyTextField(
                        controller: _bankNameController,
                        labelText: 'Bank Name',
                        hintText: 'Enter bank name',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter bank name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
              
                      // IFSC Code
                      MyTextField(
                        controller: _ifscCodeController,
                        labelText: 'IFSC Code',
                        hintText: 'Enter IFSC code',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter IFSC code';
                          }
                          // IFSC code validation pattern
                          // if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value.toUpperCase())) {
                          //   return 'Please enter valid IFSC code';
                          // }
                          return null;
                        },
                      ),
              //         const SizedBox(height: 24),
              // Center(child: Text("OR")),
              //         // UPI Section
              //         // const Text(
              //         //   'UPI Information (Optional)',
              //         //   style: TextStyle(
              //         //     fontSize: 16,
              //         //     fontWeight: FontWeight.bold,
              //         //     color: Color(0xFF001519),
              //         //   ),
              //         // ),
              //          const SizedBox(height: 24),
              
              //         // UPI ID
              //         MyTextField(
              //           controller: _upiIdController,
              //           labelText: 'UPI ID',
              //           hintText: 'Enter UPI ID (optional)',
              //           validator: (value) {
              //             if (value != null && value.trim().isNotEmpty) {
              //               // Basic UPI ID validation
              //               if (!RegExp(
              //                 r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$',
              //               ).hasMatch(value)) {
              //                 return 'Please enter valid UPI ID';
              //               }
              //             }
              //             return null;
              //           },
              //         ),
                      const SizedBox(height: 32),
              
                      // Submit Button
                      MyButton(
                        borderRadius: BorderRadius.circular(12),
                        text: 'Save Account Details',
                        textStyle: AppTypography.bodyBold(
                          color: Colors.white,
                        ),
                        color: const Color(0xFF001519),
                        onPressed: () async {
                          _submitForm();
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final accountDetails = AccountDetails(
        accountHolderName: _accountHolderNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        bankName: _bankNameController.text.trim(),
        ifscCode: _ifscCodeController.text.trim().toUpperCase(),
        upiId: _upiIdController.text.trim(),
      );

      // Return the account details to the previous screen
      context.pop(accountDetails);
    }
  }
}
