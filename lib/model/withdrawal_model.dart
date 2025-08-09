class AccountDetails {
  final String accountHolderName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String upiId;

  AccountDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.upiId,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    return AccountDetails(
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankName: json['bankName'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      upiId: json['upiId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'upiId': upiId,
    };
  }

  @override
  String toString() {
    return 'AccountDetails(accountHolderName: $accountHolderName, accountNumber: $accountNumber, bankName: $bankName, ifscCode: $ifscCode, upiId: $upiId)';
  }
}

class WithdrawalRequest {
  final double pointsRequested;
  final AccountDetails accountDetails;

  WithdrawalRequest({
    required this.pointsRequested,
    required this.accountDetails,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      pointsRequested: (json['pointsRequested'] ?? 0).toDouble(),
      accountDetails: AccountDetails.fromJson(json['accountDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pointsRequested': pointsRequested,
      'accountDetails': accountDetails.toJson(),
    };
  }

  @override
  String toString() {
    return 'WithdrawalRequest(pointsRequested: $pointsRequested, accountDetails: $accountDetails)';
  }
}

class WithdrawalResponse {
  final bool success;
  final String message;
  final String? transactionId;
  final DateTime? requestDate;

  WithdrawalResponse({
    required this.success,
    required this.message,
    this.transactionId,
    this.requestDate,
  });

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      transactionId: json['transactionId'],
      requestDate: json['requestDate'] != null 
          ? DateTime.parse(json['requestDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'transactionId': transactionId,
      'requestDate': requestDate?.toIso8601String(),
    };
  }
}
