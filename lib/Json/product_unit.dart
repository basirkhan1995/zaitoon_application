
import 'dart:convert';

ProductsUnitModel productsUnitModelFromMap(String str) => ProductsUnitModel.fromMap(json.decode(str));

String productsUnitModelToMap(ProductsUnitModel data) => json.encode(data.toMap());

class ProductsUnitModel {
  final int unitId;
  final String unitName;

  ProductsUnitModel({
    required this.unitId,
    required this.unitName,
  });

  ProductsUnitModel copyWith({
    int? unitId,
    String? unitName,
  }) =>
      ProductsUnitModel(
        unitId: unitId ?? this.unitId,
        unitName: unitName ?? this.unitName,
      );

  factory ProductsUnitModel.fromMap(Map<String, dynamic> json) => ProductsUnitModel(
    unitId: json["unitId"],
    unitName: json["unitName"],
  );

  Map<String, dynamic> toMap() => {
    "unitId": unitId,
    "unitName": unitName,
  };
}
