class SavedAccountDetails {
  final String accountHolderName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String upiId;
  final bool isDefault;
  final DateTime savedAt;

  SavedAccountDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.upiId,
    required this.isDefault,
    required this.savedAt,
  });

  factory SavedAccountDetails.fromJson(Map<String, dynamic> json) {
    return SavedAccountDetails(
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankName: json['bankName'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      upiId: json['upiId'] ?? '',
      isDefault: json['isDefault'] ?? false,
      savedAt: DateTime.parse(json['savedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'upiId': upiId,
      'isDefault': isDefault,
      'savedAt': savedAt.toIso8601String(),
    };
  }
}

class UserDetailModel {
  final String id;
  final String firstname;
  final String lastname;
  final String middlename;
  final DateTime? dob;
  final int mobile;
  final String gender;
  final String email;
  final String address1;
  final String address2;
  final String address3;
  final String state;
  final String city;
  final String pincode;
  final String country;
  final String role;
  final List<String> documentsName;
  final List<String> documentsDetails;
  final List<String> imageURL;
  final Map<String, dynamic>? aadhar;
  final Map<String, dynamic>? pan;
  final bool isVerified;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  final int? deletedAt;
  final String? deletedBy;
  final int version;
  final double availablePoints;
  final double totalPoints;
  final double redeemedPoints;
  final SavedAccountDetails? savedAccountDetails;

  UserDetailModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.middlename,
    this.dob,
    required this.mobile,
    required this.gender,
    required this.email,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.state,
    required this.city,
    required this.pincode,
    required this.country,
    required this.role,
    required this.documentsName,
    required this.documentsDetails,
    required this.imageURL,
    this.aadhar,
    this.pan,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    this.deletedBy,
    required this.version,
    required this.availablePoints,
    required this.totalPoints,
    required this.redeemedPoints,
    this.savedAccountDetails,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      middlename: json['middlename'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      mobile: json['mobile'] ?? 0,
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      address3: json['address3'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
      role: json['role'] ?? '',
      documentsName: List<String>.from(json['documentsName'] ?? []),
      documentsDetails: List<String>.from(json['documentsDetails'] ?? []),
      imageURL: List<String>.from(json['imageURL'] ?? []),
      aadhar: json['aadhar'],
      pan: json['pan'],
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      deletedBy: json['deletedBy'],
      version: json['__v'] ?? 0,
      availablePoints: (json['availablePoints'] ?? 0).toDouble(),
      totalPoints: (json['totalPoints'] ?? 0).toDouble(),
      redeemedPoints: (json['redeemedPoints'] ?? 0).toDouble(),
      savedAccountDetails: json['savedAccountDetails'] != null
          ? SavedAccountDetails.fromJson(json['savedAccountDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'dob': dob?.toIso8601String(),
      'mobile': mobile,
      'gender': gender,
      'email': email,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'state': state,
      'city': city,
      'pincode': pincode,
      'country': country,
      'role': role,
      'documentsName': documentsName,
      'documentsDetails': documentsDetails,
      'imageURL': imageURL,
      'aadhar': aadhar,
      'pan': pan,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'deletedBy': deletedBy,
      '__v': version,
      'availablePoints': availablePoints,
      'totalPoints': totalPoints,
      'redeemedPoints': redeemedPoints,
      'savedAccountDetails': savedAccountDetails?.toJson(),
    };
  }

  // Helper getters
  String get fullName => '$firstname $lastname'.trim();
  String get displayName => fullName.isNotEmpty ? fullName : email;
  String get formattedMobile => mobile.toString();
  String get completeAddress => [address1, address2, address3, city, state, pincode]
      .where((element) => element.isNotEmpty)
      .join(', ');
  
  // Aadhar and PAN helper getters
  String get aadharNumber => aadhar?['number']?.toString() ?? '';
  String get panNumber => pan?['number']?.toString() ?? '';
  
  bool get hasAadhar => aadharNumber.isNotEmpty;
  bool get hasPan => panNumber.isNotEmpty;

  @override
  String toString() {
    return 'UserDetailModel(id: $id, name: $fullName, email: $email, availablePoints: $availablePoints)';
  }
}
