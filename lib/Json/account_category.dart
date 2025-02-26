
import 'dart:convert';

import 'package:equatable/equatable.dart';

AccountCategoryModel accountCategoryFromMap(String str) => AccountCategoryModel.fromMap(json.decode(str));

String accountCategoryToMap(AccountCategoryModel data) => json.encode(data.toMap());

class AccountCategoryModel extends Equatable{
  final int accCategoryId;
  final String accCategoryName;

  const AccountCategoryModel({
    required this.accCategoryId,
    required this.accCategoryName,
  });

  AccountCategoryModel copyWith({
    int? accCategoryId,
    String? accCategoryName,
  }) =>
      AccountCategoryModel(
        accCategoryId: accCategoryId ?? this.accCategoryId,
        accCategoryName: accCategoryName ?? this.accCategoryName,
      );

  factory AccountCategoryModel.fromMap(Map<String, dynamic> json) => AccountCategoryModel(
    accCategoryId: json["accCategoryId"],
    accCategoryName: json["accCategoryName"],
  );

  Map<String, dynamic> toMap() => {
    "accCategoryId": accCategoryId,
    "accCategoryName": accCategoryName,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [
    accCategoryId,
    accCategoryName
  ];
}
