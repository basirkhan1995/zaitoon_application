import 'package:flutter/material.dart';
import 'dart:typed_data';

class InvoiceDetails {
  String clientName;
  String clientPhone;
  String clientAddress;
  String clientEmail;
  String invoiceNumber;
  String dueDate;
  String invoiceDate;
  String currency;
  String invoiceCurrency;
  String supplier;
  String supplierAddress;
  String supplierMobile;
  String supplierTelephone;
  String termsAndCondition;
  String supplierEmail;
  Uint8List? logo;

  InvoiceDetails(
      {this.clientName = "",
      this.clientEmail = "",
      this.clientPhone = "",
      this.clientAddress = "",
      this.supplierEmail = "",
      this.invoiceNumber = "",
      this.termsAndCondition = "",
      this.dueDate = "",
      this.currency = "",
      this.invoiceDate = "",
      this.invoiceCurrency = "",
      this.supplier = "",
      this.logo,
      this.supplierAddress = "",
      this.supplierTelephone = "",
      this.supplierMobile = ""});
}

class InvoiceItems {
  int? rowNumber;
  int? invDetailId;
  int? itemId;
  String itemName;
  int? invoiceId;
  int quantity;
  double amount;
  double tax;
  double discount;
  double total;
  TextEditingController? controller;
  FocusNode? focusNode;
  InvoiceItems({
    this.rowNumber,
    this.invDetailId,
    this.itemId,
    this.itemName = "",
    this.invoiceId,
    this.controller,
    this.quantity = 1,
    this.amount = 0,
    this.discount = 0,
    this.tax = 0,
    this.total = 0,
    this.focusNode,
  });

  InvoiceItems copyWith({
    TextEditingController? controller,
    int? quantity,
    double? amount,
    double? discount,
    double? tax,
    double? total,
    int? itemId,
    String? itemName,
    FocusNode? focusNode,
  }) {
    return InvoiceItems(
      controller: controller ?? this.controller,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      focusNode: focusNode ?? this.focusNode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "invDetailsId": invDetailId,
      "invoiceItemId": itemId,
      "invId": invoiceId,
      "qty": quantity,
      "amount": amount,
      "tax": tax,
      "discount": discount,
      "totalAmount": total,
    };
  }
}
