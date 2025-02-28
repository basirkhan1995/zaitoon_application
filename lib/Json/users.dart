import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'dart:typed_data';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users extends Equatable {
  final int? userId;
  final String? businessName;
  final int? businessId;
  final int? accId;
  final String? accountName;
  final String? email;
  final String? address;
  final String? mobile1;
  final String? mobile2;
  final Uint8List? companyLogo;
  final String? accountCategory;
  final String? username;
  final String? password;
  final int? userStatus;
  final int? userRoleId;

  const Users({
    this.userId,
    this.businessName,
    this.accountCategory,
    this.businessId,
    this.accId,
    this.email,
    this.address,
    this.accountName,
    this.mobile1,
    this.mobile2,
    this.companyLogo,
    this.username,
    this.password,
    this.userStatus,
    this.userRoleId,
  });

  Users copyWith({
    int? userId,
    String? businessName,
    int? businessId,
    String? ownerName,
    String? accountName,
    String? email,
    int? accId,
    String? categoryName,
    int? usrOwner,
    String? address,
    String? mobile1,
    String? mobile2,
    Uint8List? companyLogo,
    String? username,
    String? password,
    int? userStatus,
    int? userRoleId,
  }) =>
      Users(
          userId: userId ?? this.userId,
          businessName: businessName ?? this.businessName,
          businessId: businessId ?? this.businessId,
          accId: accId ?? this.accId,
          email: email ?? this.email,
          address: address ?? this.address,
          accountCategory: accountCategory,
          mobile1: mobile1 ?? this.mobile1,
          mobile2: mobile2 ?? this.mobile2,
          companyLogo: companyLogo ?? this.companyLogo,
          accountName: accountName ?? this.accountName,
          username: username ?? this.username,
          password: password ?? this.password,
          userStatus: userStatus ?? this.userStatus,
          userRoleId: userRoleId ?? this.userId,
          );

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["usrId"],
        businessName: json["businessName"],
        businessId: json["bId"],
        accId: json["accId"],
        accountName: json["accountName"],
        email: json["email"],
        address: json["address"],
        accountCategory: json["accCategoryName"],
        mobile1: json["mobile1"],
        mobile2: json["mobile2"],
        companyLogo: json["companyLogo"],
        username: json["username"],
        password: json["password"],
        userStatus: json["userStatus"],
        userRoleId: json["roleId"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": userId,
        "businessName": businessName,
        "bId": businessId,
        "accCategoryName":accountCategory,
        "accId": accId,
        "accountName":accountName,
        "email": email,
        "address": address,
        "mobile1": mobile1,
        "mobile2": mobile2,
        "companyLogo": companyLogo,
        "username": username,
        "password": password,
        "userStatus": userStatus,
        "roleId": userRoleId
      };

  @override
  List<Object?> get props => [
        userId,
        username,
        password,
        businessName,
        companyLogo,
        email,
        accountCategory,
        address,
        mobile1,
        mobile2,
        userRoleId,
        accId,
        accountName
      ];
}
