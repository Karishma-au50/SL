import 'package:flutter/material.dart';

class WalletHistoryModel {
  final List<WithdrawalRequest> data;

  WalletHistoryModel({required this.data});

  factory WalletHistoryModel.fromJson(List<dynamic> json) {
    return WalletHistoryModel(
      data:
          (json as List<dynamic>?)
              ?.map(
                (item) =>
                    WithdrawalRequest.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((item) => item.toJson()).toList()};
  }

  // Helper methods
  List<WithdrawalRequest> get pendingRequests =>
      data.where((request) => request.isPending).toList();

  List<WithdrawalRequest> get completedRequests =>
      data.where((request) => request.isCompleted).toList();

  List<WithdrawalRequest> get rejectedRequests =>
      data.where((request) => request.isRejected).toList();

  List<WithdrawalRequest> get approvedRequests =>
      data.where((request) => request.isApproved).toList();

  int get totalPendingAmount =>
      pendingRequests.fold(0, (sum, request) => sum + request.pointsRequested);

  int get totalCompletedAmount => completedRequests.fold(
    0,
    (sum, request) => sum + request.pointsRequested,
  );

  int get totalApprovedAmount =>
      approvedRequests.fold(0, (sum, request) => sum + request.pointsRequested);

  int get totalRejectedAmount =>
      rejectedRequests.fold(0, (sum, request) => sum + request.pointsRequested);

  @override
  String toString() {
    return 'WalletHistoryModel(data: $data)';
  }
}

class WithdrawalRequest {
  final String id;
  final String userId;
  final int pointsRequested;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final AccountDetail accountDetails;
  final String? adminNotes;
  final DateTime? processedAt;
  final ProcessedBy? processedBy;

  WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.pointsRequested,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.accountDetails,
    this.adminNotes,
    this.processedAt,
    this.processedBy,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      pointsRequested: json['pointsRequested'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      version: json['__v'] as int? ?? 0,
      accountDetails: AccountDetail.fromJson(
        json['accountDetails'] as Map<String, dynamic>? ?? {},
      ),
      adminNotes: json['adminNotes'] as String?,
      processedAt: json['processedAt'] != null
          ? DateTime.tryParse(json['processedAt'] as String)
          : null,
      processedBy: json['processedBy'] != null
          ? ProcessedBy.fromJson(json['processedBy'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'pointsRequested': pointsRequested,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'accountDetails': accountDetails.toJson(),
      if (adminNotes != null) 'adminNotes': adminNotes,
      if (processedAt != null) 'processedAt': processedAt!.toIso8601String(),
      if (processedBy != null) 'processedBy': processedBy!.toJson(),
    };
  }

  // Helper methods
  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'processing':
        return 'Processing';
      default:
        return status.toUpperCase();
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'processing':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_actions;
      case 'approved':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'processing':
        return Icons.sync;
      default:
        return Icons.help;
    }
  }

  // status widget
  Widget get stutusWidget {
    switch (status.toLowerCase()) {
      case 'pending':
        return CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        );
      case 'approved':
        return CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        );
      case 'completed':
        return Image.asset('assets/images/complete.png', height: 48, width: 48);
      case 'rejected':
        return Image.asset('assets/images/cancel.png', height: 48, width: 48);
      case 'processing':
        return CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        );
      default:
        return CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.1),
          child: Icon(Icons.help, color: Colors.grey),
        );
    }
  }

  // Formatted amount color
  Color get formattedAmountColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'processing':
        return Colors.purple;
      default:
        return Colors.black87;
    }
  }

  String get formattedAmount {
    return '₹${pointsRequested.toString()}';
  }

  String get formattedCreatedDate {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }

  String get formattedCreatedDateTime {
    return '$formattedCreatedDate ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  String get formattedProcessedDate {
    if (processedAt == null) return 'N/A';
    return '${processedAt!.day.toString().padLeft(2, '0')}/${processedAt!.month.toString().padLeft(2, '0')}/${processedAt!.year}';
  }

  String get formattedProcessedDateTime {
    if (processedAt == null) return 'N/A';
    return '$formattedProcessedDate ${processedAt!.hour.toString().padLeft(2, '0')}:${processedAt!.minute.toString().padLeft(2, '0')}';
  }

  String get timeSinceCreated {
    // Example: 26 Aug, 2025 | 10:30 PM
    final day = createdAt.day.toString().padLeft(2, '0');
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[createdAt.month - 1];
    final year = createdAt.year;
    final hour = createdAt.hour % 12 == 0 ? 12 : createdAt.hour % 12;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = createdAt.hour >= 12 ? 'PM' : 'AM';
    return '$day $month, $year | $hour:$minute $period';
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isProcessing => status.toLowerCase() == 'processing';

  @override
  String toString() {
    return 'WithdrawalRequest(id: $id, pointsRequested: $pointsRequested, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawalRequest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AccountDetail {
  final String accountHolderName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String upiId;

  AccountDetail({
    required this.accountHolderName,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.upiId,
  });

  factory AccountDetail.fromJson(Map<String, dynamic> json) {
    return AccountDetail(
      accountHolderName: json['accountHolderName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      ifscCode: json['ifscCode'] as String? ?? '',
      upiId: json['upiId'] as String? ?? '',
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

  // Helper methods for secure display
  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    final visibleDigits = accountNumber.substring(accountNumber.length - 4);
    return 'XXXX$visibleDigits';
  }

  String get maskedUpiId {
    if (upiId.contains('@')) {
      final parts = upiId.split('@');
      if (parts[0].length <= 2) return upiId;
      final maskedUsername = '${parts[0].substring(0, 2)}***';
      return '$maskedUsername@${parts[1]}';
    }
    return upiId;
  }

  String get displayBankInfo {
    return '$bankName ($maskedAccountNumber)';
  }

  String get shortBankName {
    // Extract acronym from bank name
    final words = bankName.split(' ');
    if (words.length > 1) {
      return words
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
          .join('');
    }
    return bankName.length > 3
        ? bankName.substring(0, 3).toUpperCase()
        : bankName.toUpperCase();
  }

  @override
  String toString() {
    return 'AccountDetail(accountHolderName: $accountHolderName, bankName: $bankName, maskedAccountNumber: $maskedAccountNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountDetail &&
        other.accountHolderName == accountHolderName &&
        other.accountNumber == accountNumber &&
        other.bankName == bankName &&
        other.ifscCode == ifscCode &&
        other.upiId == upiId;
  }

  @override
  int get hashCode {
    return accountHolderName.hashCode ^
        accountNumber.hashCode ^
        bankName.hashCode ^
        ifscCode.hashCode ^
        upiId.hashCode;
  }
}

class ProcessedBy {
  final String id;
  final String firstname;
  final String lastname;

  ProcessedBy({
    required this.id,
    required this.firstname,
    required this.lastname,
  });

  factory ProcessedBy.fromJson(Map<String, dynamic> json) {
    return ProcessedBy(
      id: json['_id'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'firstname': firstname, 'lastname': lastname};
  }

  String get fullName => '$firstname $lastname'.trim();

  String get initials {
    final first = firstname.isNotEmpty ? firstname[0].toUpperCase() : '';
    final last = lastname.isNotEmpty ? lastname[0].toUpperCase() : '';
    return '$first$last';
  }

  @override
  String toString() {
    return 'ProcessedBy(id: $id, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessedBy && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
