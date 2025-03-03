import 'package:flutter/material.dart';

class InvoiceDetails {
  String clientName;
  String invoiceNumber;
  String? invoiceDate;
  String? invoiceDueDate;
  double subtotal;
  double vat;
  double discount;
  double total;

  InvoiceDetails({
    this.clientName = "",
    this.invoiceNumber = "INV000001",
    this.invoiceDate,
    this.invoiceDueDate,
    this.subtotal = 0,
    this.vat = 0,
    this.discount = 0,
    this.total = 0,
  });

  InvoiceDetails copyWith({
    String? clientName,
    String? invoiceNumber,
    String? invoiceDate,
    String? invoiceDueDate,
    double? subtotal,
    double? vat,
    double? discount,
    double? total,
  }) {
    return InvoiceDetails(
      clientName: clientName ?? this.clientName,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      invoiceDueDate: invoiceDueDate ?? this.invoiceDueDate,
      subtotal: subtotal ?? this.subtotal,
      vat: vat ?? this.vat,
      discount: discount ?? this.discount,
      total: total ?? this.total,
    );
  }

  // Calculate the total after discount and VAT
  double calculateTotal() {
    return subtotal + calculateVAT() - calculateDiscount();
  }

  // Calculate the discount amount
  double calculateDiscount() {
    return subtotal * (discount / 100);
  }

  // Calculate the subtotal (for example, sum of item totals)
  double calculateSubtotal(List<InvoiceItems> items) {
    double total = 0;
    for (var item in items) {
      total += item.amount * item.quantity; // price * quantity
    }
    return total;
  }

  // Calculate VAT based on subtotal
  double calculateVAT() {
    return subtotal * (vat / 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate,
      'invoiceDueDate': invoiceDueDate,
      'subtotal': subtotal,
      'vat': vat,
      'discount': discount,
      'total': total,
    };
  }

  static InvoiceDetails fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      clientName: json['clientName'],
      invoiceNumber: json['invoiceNumber'],
      invoiceDate: json['invoiceDate'],
      invoiceDueDate: json['invoiceDueDate'],
      subtotal: json['subtotal'],
      vat: json['vat'],
      discount: json['discount'],
      total: json['total'],
    );
  }
}

class InvoiceItems {
  int? rowNumber;
  String itemName;
  int quantity;
  double amount;
  double total;
  TextEditingController? controller;
  FocusNode? focusNode;

  InvoiceItems({
    this.rowNumber,
    this.itemName = "",
    this.controller,
    this.quantity = 1,
    this.amount = 0,
    this.total = 0,
    this.focusNode,
  });

  InvoiceItems copyWith({
    int? rowNumber,
    String? itemName,
    int? quantity,
    double? amount,
    double? total,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return InvoiceItems(
      rowNumber: rowNumber ?? this.rowNumber,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      total: total ?? this.total,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rowNumber': rowNumber,
      'itemName': itemName,
      'quantity': quantity,
      'amount': amount,
      'total': total,
    };
  }

  static InvoiceItems fromJson(Map<String, dynamic> json) {
    return InvoiceItems(
      rowNumber: json['rowNumber'],
      itemName: json['itemName'],
      quantity: json['quantity'],
      amount: json['amount'],
      total: json['total'],
    );
  }
}

// class InvoiceDetails {
//   String? clientName;
//   String? invoiceNumber;
//   String? invoiceDate;
//   String? invoiceDueDate;
//   double? subtotal;
//   double? vat;
//   double? discount;
//   double? total;

//   InvoiceDetails(
//       {this.clientName = "",
//       this.invoiceNumber = "INV000001",
//       this.invoiceDate,
//       this.invoiceDueDate,
//       this.subtotal = 0,
//       this.vat = 0,
//       this.discount = 0,
//       this.total = 0});

//   InvoiceDetails copyWith({
//     String? clientName,
//     String? invoiceNumber,
//     String? invoiceDate,
//     String? invoiceDueDate,
//     double? subtotal,
//     double? vat,
//     double? discount,
//     double? total,
//   }) {
//     return InvoiceDetails(
//         clientName: clientName ?? this.clientName,
//         invoiceNumber: invoiceNumber ?? this.invoiceNumber,
//         invoiceDate: invoiceDate ?? this.invoiceDate,
//         invoiceDueDate: invoiceDueDate ?? this.invoiceDueDate,
//         subtotal: subtotal ?? this.subtotal,
//         vat: vat ?? this.vat,
//         discount: discount ?? this.discount,
//         total: total ?? this.total);
//   }
// }

// class InvoiceItems {
//   int? rowNumber;
//   String itemName;
//   int quantity;
//   double amount;
//   double total;
//   TextEditingController? controller;
//   FocusNode? focusNode;
//   InvoiceItems({
//     this.rowNumber,
//     this.itemName = "",
//     this.controller,
//     this.quantity = 1,
//     this.amount = 0,
//     this.total = 0,
//     this.focusNode,
//   });

//   InvoiceItems copyWith({
//     int? rowNumber,
//     String? itemName,
//     int? quantity,
//     double? amount,
//     double? total,
//     TextEditingController? controller,
//     FocusNode? focusNode,
//   }) {
//     return InvoiceItems(
//       rowNumber: rowNumber ?? this.rowNumber,
//       itemName: itemName ?? this.itemName,
//       quantity: quantity ?? this.quantity,
//       amount: amount ?? this.amount,
//       total: total ?? this.total,
//       controller: controller ?? this.controller,
//       focusNode: focusNode ?? this.focusNode,
//     );
//   }
// }
