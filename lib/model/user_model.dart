import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class UserModel {
  String? id;
  String? firstname;
  String? lastname;
  String? middlename;
  int? dob;
  int? mobile;
  String? gender;
  String? email;
  String? address1;
  String? address2;
  String? address3;
  String? state;
  String? city;
  String? pincode;
  String? country;
  String? role;
  Map<String, dynamic>? aadhar;
  Map<String, dynamic>? pan;
  bool? isVerified;
  int? createdAt;
  int? updatedAt;
  bool? isDeleted;
  int? deletedAt;
  String? deletedBy;

  UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.middlename,
    this.dob,
    this.mobile,
    this.gender,
    this.email,
    this.address1,
    this.address2,
    this.address3,
    this.state,
    this.city,
    this.pincode,
    this.country,
    this.role,
    this.aadhar,
    this.pan,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.deletedBy,
  });
  UserModel copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? middlename,
    int? dob,
    int? mobile,
    String? gender,
    String? email,
    String? address1,
    String? address2,
    String? address3,
    String? state,
    String? city,
    String? pincode,
    String? country,
    String? role,
    Map<String, dynamic>? aadhar,
    Map<String, dynamic>? pan,
    bool? isVerified,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? deletedAt,
    String? deletedBy,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      middlename: middlename ?? this.middlename,
      dob: dob ?? this.dob,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      state: state ?? this.state,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      country: country ?? this.country,
      role: role ?? this.role,
      aadhar: aadhar,
      pan: pan,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      dob: json['dob'],
      mobile: json['mobile'],
      gender: json['gender'],
      email: json['email'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      state: json['state'],
      city: json['city'],
      pincode: json['pincode'],
      country: json['country'],
      role: json['role'],
      aadhar: json["aadhar"],
      pan: json["pan"],
      isVerified: json['isVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'],
      deletedBy: json['deletedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    // if aadhar["images"] file is File then remove the key
    Map<String, dynamic> dupAadhar = {};
    if (aadhar != null ) {
      dupAadhar = {...aadhar!};
      dupAadhar.remove("images");
    }

    Map<String, dynamic> dupPan = {};
    if (pan != null) {
      dupPan = {...pan!};
      dupPan.remove("images");
    }

    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'dob': dob,
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
      'aadhar': dupAadhar,
      'pan': dupPan,
      'isVerified': isVerified,
    };
  }

  // comvert to FormData
  FormData toFormData() {
    FormData data = FormData.fromMap(toJson());
    // aadhar and pan images contain value type of file then add this to formdata file
    if (aadhar != null) {
      for (var file in aadhar!["images"]) {
        data.files.add(
          MapEntry(
            "aadharImages",
            MultipartFile.fromFileSync(
              file.path,
              filename: file.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (pan != null) {
      for (var file in pan!["images"] ) {
        if(file==null) continue;
        data.files.add(
          MapEntry(
            "panImages",
            MultipartFile.fromFileSync(
              file.path,
              filename: file.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    return data;
  }
}
