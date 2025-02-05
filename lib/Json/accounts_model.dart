// To parse this JSON data, do
//
//     final accounts = accountsFromMap(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Accounts accountsFromMap(String str) => Accounts.fromMap(json.decode(str));

String accountsToMap(Accounts data) => json.encode(data.toMap());

class Accounts extends Equatable {
  final int? accId;
  final String? accountNumber;
  final String? accountName;
  final String? address;
  final String? mobile;
  final String? email;
  final String? accCategoryName;
  final int? accCategoryId;
  final String? currencyCode;
  final int? createdBy;
  final String? accountCreatedAt;
  final String? accountUpdatedAt;

  Accounts({
    this.accId,
    this.accountNumber,
    this.accountName,
    this.address,
    this.mobile,
    this.email,
    this.accCategoryName,
    this.accCategoryId,
    this.currencyCode,
    this.createdBy,
    this.accountCreatedAt,
    this.accountUpdatedAt,
  });

  Accounts copyWith({
    int? accId,
    String? accountNumber,
    String? accountName,
    String? address,
    String? mobile,
    String? email,
    String? accCategoryName,
    int? accCategoryId,
    String? currencyCode,
    int? createdBy,
    String? accountCreatedAt,
    String? accountUpdatedAt,
  }) =>
      Accounts(
        accId: accId ?? this.accId,
        accountNumber: accountNumber ?? this.accountNumber,
        accountName: accountName ?? this.accountName,
        address: address ?? this.address,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        accCategoryName: accCategoryName ?? this.accCategoryName,
        accCategoryId: accCategoryId ?? this.accCategoryId,
        currencyCode: currencyCode ?? this.currencyCode,
        createdBy: createdBy ?? this.createdBy,
        accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
        accountUpdatedAt: accountUpdatedAt ?? this.accountUpdatedAt,
      );

  factory Accounts.fromMap(Map<String, dynamic> json) => Accounts(
        accId: json["accId"],
        accountNumber: json["accountNumber"],
        accountName: json["accountName"],
        address: json["address"],
        mobile: json["mobile"],
        email: json["email"],
        accCategoryName: json["accCategoryName"],
        accCategoryId: json["accCategoryId"],
        currencyCode: json["currency_code"],
        createdBy: json["createdBy"],
        accountCreatedAt: json["accountCreatedAt"],
        accountUpdatedAt: json["accountUpdatedAt"],
      );

  Map<String, dynamic> toMap() => {
        "accId": accId,
        "accountNumber": accountNumber,
        "accountName": accountName,
        "address": address,
        "mobile": mobile,
        "email": email,
        "accCategoryName": accCategoryName,
        "accCategoryId": accCategoryId,
        "currency_code": currencyCode,
        "createdBy": createdBy,
        "accountCreatedAt": accountCreatedAt,
        "accountUpdatedAt": accountUpdatedAt,
      };

  @override
  List<Object?> get props => [
        accId,
        accountNumber,
        accountName,
        address,
        mobile,
        email,
        currencyCode,
        accCategoryName,
        accCategoryId,
        createdBy,
        accountCreatedAt,
        accountUpdatedAt,
      ];
}
