import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/model/base_model.dart';

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
  List<String>? documentsName;
  List<String>? documentsDetails;
  List<String>? images;
  bool? isVerified;
  int? createdAt;
  int? updatedAt;
  bool? isDeleted;
  int? deletedAt;
  String? deletedBy;
  int? v;

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
    this.documentsName = const [],
    this.documentsDetails = const [],
    this.images = const [],
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.deletedBy,
    this.v,
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
    List<String>? documentsName,
    List<String>? documentsDetails,
    List<String>? images,
    bool? isVerified,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
    int? deletedAt,
    String? deletedBy,
    int? v,
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
      documentsName: documentsName ?? this.documentsName,
      documentsDetails: documentsDetails ?? this.documentsDetails,
      images: images ?? this.images,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      v: v ?? this.v,
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
      documentsName: List<String>.from(json['documentsName'] ?? []),
      documentsDetails: List<String>.from(json['documentsDetails'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      isVerified: json['isVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'],
      deletedBy: json['deletedBy'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      // 'dob': dob,
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
      'images': images,
      'isVerified': isVerified,
      // 'createdAt': createdAt,
      // 'updatedAt': updatedAt,
      // 'isDeleted': isDeleted,
      // 'deletedAt': deletedAt,
      // 'deletedBy': deletedBy,
      '__v': v,
    };
  }

  // comvert to FormData
  FormData toFormData() {
    return FormData.fromMap(toJson());
  }
}
