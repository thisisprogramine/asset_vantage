
import 'package:asset_vantage/src/domain/entities/partnership/holdings_entity.dart';

class HoldingsModel extends HoldingsEntity{
  List<HoldingData> holdingsList;

  HoldingsModel({
    required this.holdingsList,
  }) : super(
    holding: holdingsList
  );

  factory HoldingsModel.fromJson(Map<String, dynamic> json) => HoldingsModel(
    holdingsList: List<HoldingData>.from(json["result"].map((x) => HoldingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(holdingsList.map((x) => x.toJson())),
  };
}

class HoldingData extends Holding{
  String name;
  String id;
  String label;
  String searchText;
  String value;
  bool? isCheck;

  HoldingData({
    required this.name,
    required this.id,
    required this.label,
    required this.searchText,
    required this.value,
    this.isCheck,
  }) :super(
    name: name,
    id: id,
    label: label,
    searchText: searchText,
    value: value,
    isCheck: isCheck,
  );

  factory HoldingData.fromJson(Map<String, dynamic> json) => HoldingData(
    name: json["name"],
    id: json["id"],
    label: json["label"],
    searchText: json["searchText"],
    value: json["value"],
    isCheck: json["isCheck"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "label": label,
    "searchText": searchText,
    "value": value,
    "isCheck": isCheck,
  };
}
