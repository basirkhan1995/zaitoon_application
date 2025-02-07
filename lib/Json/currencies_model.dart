import 'dart:convert';
import 'package:equatable/equatable.dart';

CurrenciesModel currenciesModelFromMap(String str) => CurrenciesModel.fromMap(json.decode(str));

String currenciesModelToMap(CurrenciesModel data) => json.encode(data.toMap());

class CurrenciesModel extends Equatable{
  final int? currencyId;
  final String currencyCode;
  final String? currencyName;
  final String? symbol;
  final int? isDefault;

  const CurrenciesModel({
    this.currencyId,
    required this.currencyCode,
    this.currencyName,
    this.symbol,
    this.isDefault,
  });

  CurrenciesModel copyWith({
    int? currencyId,
    String? currencyCode,
    String? currencyName,
    String? symbol,
    int? isDefault,
  }) =>
      CurrenciesModel(
        currencyId: currencyId ?? this.currencyId,
        currencyCode: currencyCode ?? this.currencyCode,
        currencyName: currencyName ?? this.currencyName,
        symbol: symbol ?? this.symbol,
        isDefault: isDefault ?? this.isDefault,
      );

  factory CurrenciesModel.fromMap(Map<String, dynamic> json) => CurrenciesModel(
    currencyId: json["currency_id"],
    currencyCode: json["currency_code"],
    currencyName: json["currency_name"],
    symbol: json["symbol"],
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toMap() => {
    "currency_id": currencyId,
    "currency_code": currencyCode,
    "currency_name": currencyName,
    "symbol": symbol,
    "isDefault": isDefault,
  };

  @override
  List<Object?> get props => [currencyId,currencyCode,currencyName,symbol, isDefault];
}
