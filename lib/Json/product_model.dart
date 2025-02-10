import 'dart:convert';

ProductsModel productsModelFromMap(String str) =>
    ProductsModel.fromMap(json.decode(str));

String productsModelToMap(ProductsModel data) => json.encode(data.toMap());

class ProductsModel {
  final int? proInvId;
  final int? productId;
  final String? productName;
  final double? buyPrice;
  final double? sellPrice;
  final int? qty;
  final String? inventoryType;
  final int? totalInventory;
  final int? unitId;
  final String? unitName;
  final int? pcId;
  final String? pcName;
  final int? productSerial;
  final int? invId;
  final String? inventoryName;
  final String? lastUpdated;

  ProductsModel({
    this.proInvId,
    this.productId,
    this.productName,
    this.buyPrice,
    this.sellPrice,
    this.qty,
    this.inventoryType,
    this.totalInventory,
    this.unitId,
    required this.unitName,
    this.pcId,
    this.pcName,
    this.productSerial,
    this.invId,
    this.inventoryName,
    this.lastUpdated,
  });

  ProductsModel copyWith({
    int? proInvId,
    int? productId,
    String? productName,
    double? buyPrice,
    double? sellPrice,
    int? qty,
    String? inventoryType,
    int? totalInventory,
    int? unitId,
    String? unitName,
    int? pcId,
    String? pcName,
    int? productSerial,
    int? invId,
    String? inventoryName,
    String? lastUpdated,
  }) =>
      ProductsModel(
        proInvId: proInvId ?? this.proInvId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        buyPrice: buyPrice ?? this.buyPrice,
        sellPrice: sellPrice ?? this.sellPrice,
        qty: qty ?? this.qty,
        inventoryType: inventoryType ?? this.inventoryType,
        totalInventory: totalInventory ?? this.totalInventory,
        unitId: unitId ?? this.unitId,
        unitName: unitName ?? this.unitName,
        pcId: pcId ?? this.pcId,
        pcName: pcName ?? this.pcName,
        productSerial: productSerial ?? this.productSerial,
        invId: invId ?? this.invId,
        inventoryName: inventoryName ?? this.inventoryName,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  factory ProductsModel.fromMap(Map<String, dynamic> json) => ProductsModel(
        proInvId: json["proInvId"],
        productId: json["productId"],
        productName: json["productName"],
        buyPrice: json["buyPrice"]?.toDouble(),
        sellPrice: json["sellPrice"]?.toDouble(),
        qty: json["qty"],
        inventoryType: json["inventoryType"],
        totalInventory: json["totalInventory"],
        unitId: json["unitId"],
        unitName: json["unitName"],
        pcId: json["pcId"],
        pcName: json["pcName"],
        productSerial: json["productSerial"],
        invId: json["invId"],
        inventoryName: json["inventoryName"],
        lastUpdated: json["last_updated"],
      );

  Map<String, dynamic> toMap() => {
        "proInvId": proInvId,
        "productId": productId,
        "productName": productName,
        "buyPrice": buyPrice,
        "sellPrice": sellPrice,
        "qty": qty,
        "inventoryType": inventoryType,
        "totalInventory": totalInventory,
        "unitId": unitId,
        "unitName": unitName,
        "pcId": pcId,
        "pcName": pcName,
        "productSerial": productSerial,
        "invId": invId,
        "inventoryName": inventoryName,
        "last_updated": lastUpdated,
      };
}
