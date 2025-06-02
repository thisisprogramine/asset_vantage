
import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';

class CurrencyModel extends CurrencyEntity{
  final List<CurrencyData>? currencyList;

  CurrencyModel({
    this.currencyList,
  }) : super(
    list: currencyList
  );

  factory CurrencyModel.fromJson(Map<dynamic, dynamic> json) => CurrencyModel(
    currencyList: json["currencylist"] == null ? [] : List<CurrencyData>.from(json["currencylist"]!.map((x) => CurrencyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "currencylist": currencyList == null ? [] : List<dynamic>.from(currencyList!.map((x) => x.toJson())),
  };
}

class CurrencyData extends Currency{
  final String? id;
  final String? code;
  final String? format;

  CurrencyData({
    this.id,
    this.code,
    this.format,
  }) : super(
    id: id,
    code: code,
    format: format,
  );

  factory CurrencyData.fromJson(Map<dynamic, dynamic> json) => CurrencyData(
    id: json["id"].toString(),
    code: json["code"],
    format: json["format"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "format": format,
  };
}