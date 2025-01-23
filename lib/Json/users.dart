// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'dart:typed_data';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users extends Equatable {
  final int? userId;
  final String? businessName;
  final String? fullName;
  final String? email;
  final String? address;
  final String? phone;
  final String? telephone;
  final Uint8List? companyLogo;
  final String? username;
  final String? password;

  Users({
    this.userId,
    this.businessName,
    this.fullName,
    this.email,
    this.address,
    this.phone,
    this.telephone,
    this.companyLogo,
    this.username,
    this.password,
  });

  Users copyWith({
    int? userId,
    String? businessName,
    String? fullName,
    String? email,
    String? address,
    String? phone,
    String? telephone,
    Uint8List? companyLogo,
    String? username,
    String? password,
  }) =>
      Users(
        userId: userId ?? this.userId,
        businessName: businessName ?? this.businessName,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        telephone: telephone ?? this.telephone,
        companyLogo: companyLogo ?? this.companyLogo,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        businessName: json["businessName"],
        fullName: json["fullName"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        telephone: json["telephone"],
        companyLogo: json["companyLogo"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "businessName": businessName,
        "fullName": fullName,
        "email": email,
        "address": address,
        "phone": phone,
        "telephone": telephone,
        "companyLogo": companyLogo,
        "username": username,
        "password": password,
      };

  @override
  List<Object?> get props => [
        userId,
        username,
        password,
        fullName,
        businessName,
        email,
        address,
        phone,
        telephone,
      ];
}
