import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'dart:typed_data';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users extends Equatable {
  final int? userId;
  final String? businessName;
  final int? businessId;
  final String? ownerName;
  final String? email;
  final String? address;
  final String? mobile1;
  final String? mobile2;
  final Uint8List? companyLogo;
  final String? username;
  final String? password;
  final int? userStatus;
  final int? userRoleId;

  const Users({
    this.userId,
    this.businessName,
    this.businessId,
    this.ownerName,
    this.email,
    this.address,
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
    String? email,
    String? address,
    String? mobile1,
    String? mobile2,
    Uint8List? companyLogo,
    String? username,
    String? password,
    int? userStatus,
    int? userRoleId,
    String? userRoleName,
  }) =>
      Users(
          userId: userId ?? this.userId,
          businessName: businessName ?? this.businessName,
          businessId: businessId ?? this.businessId,
          ownerName: ownerName ?? this.ownerName,
          email: email ?? this.email,
          address: address ?? this.address,
          mobile1: mobile1 ?? mobile1,
          mobile2: mobile2 ?? this.mobile2,
          companyLogo: companyLogo ?? this.companyLogo,
          username: username ?? this.username,
          password: password ?? this.password,
          userStatus: userStatus ?? this.userStatus,
          userRoleId: userRoleId ?? userId,
          );

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        businessName: json["businessName"],
        businessId: json["bId"],
        ownerName: json["ownerName"],
        email: json["email"],
        address: json["address"],
        mobile1: json["mobile1"],
        mobile2: json["mobile2"],
        companyLogo: json["companyLogo"],
        username: json["username"],
        password: json["password"],
        userStatus: json["userStatus"],
        userRoleId: json["roleId"],

      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "businessName": businessName,
        "bId": businessId,
        "fullName": ownerName,
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
        ownerName,
        businessName,
        companyLogo,
        email,
        address,
        mobile1,
        mobile2,
        userRoleId
      ];
}
