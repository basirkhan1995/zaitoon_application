import 'package:flutter/cupertino.dart';

class ZEstimateModel {
  int? rowNumber;
  int? itemId;
  String itemName;
  int quantity;
  double amount;
  double tax;
  double discount;
  double total;
  TextEditingController? controller;
  FocusNode? focusNode;
  ZEstimateModel({
    this.rowNumber,
    this.itemId,
    this.itemName = "",
    this.controller,
    this.quantity = 1,
    this.amount = 0,
    this.discount = 0,
    this.tax = 0,
    this.total = 0,
    this.focusNode,
  });

  ZEstimateModel copyWith({
    TextEditingController? controller,
    int? quantity,
    double? amount,
    double? discount,
    double? tax,
    double? total,
    int? rowNumber,
    int? itemId,
    String? itemName,
    FocusNode? focusNode,
  }) {
    return ZEstimateModel(
      controller: controller ?? this.controller,
      quantity: quantity ?? this.quantity,
      rowNumber: rowNumber ?? this.rowNumber,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      focusNode: focusNode ?? this.focusNode,
    );
  }
}
