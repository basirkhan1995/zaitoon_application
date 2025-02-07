
import 'dart:convert';

ProductsCategoryModel productsCategoryModelFromMap(String str) => ProductsCategoryModel.fromMap(json.decode(str));

String productsCategoryModelToMap(ProductsCategoryModel data) => json.encode(data.toMap());

class ProductsCategoryModel {
  final int pcId;
  final String pcName;

  ProductsCategoryModel({
    required this.pcId,
    required this.pcName,
  });

  ProductsCategoryModel copyWith({
    int? pcId,
    String? pcName,
  }) =>
      ProductsCategoryModel(
        pcId: pcId ?? this.pcId,
        pcName: pcName ?? this.pcName,
      );

  factory ProductsCategoryModel.fromMap(Map<String, dynamic> json) => ProductsCategoryModel(
    pcId: json["pcId"],
    pcName: json["pcName"],
  );

  Map<String, dynamic> toMap() => {
    "pcId": pcId,
    "pcName": pcName,
  };
}
