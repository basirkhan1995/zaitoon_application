
import 'dart:convert';

InventoryModel inventoryModelFromMap(String str) => InventoryModel.fromMap(json.decode(str));

String inventoryModelToMap(InventoryModel data) => json.encode(data.toMap());

class InventoryModel {
  final int inventoryId;
  final String inventoryName;

  InventoryModel({
    required this.inventoryId,
    required this.inventoryName,
  });

  InventoryModel copyWith({
    int? inventoryId,
    String? inventoryName,
  }) =>
      InventoryModel(
        inventoryId: inventoryId ?? this.inventoryId,
        inventoryName: inventoryName ?? this.inventoryName,
      );

  factory InventoryModel.fromMap(Map<String, dynamic> json) => InventoryModel(
    inventoryId: json["invId"],
    inventoryName: json["inventoryName"],
  );

  Map<String, dynamic> toMap() => {
    "invId": inventoryId,
    "inventoryName": inventoryName,
  };
}
