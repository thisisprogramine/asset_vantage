
import 'package:asset_vantage/src/domain/entities/partnership/partnership_entity.dart';

class PartnershipModel extends PartnershipEntity{
  List<PartnershipData> partnershipList;

  PartnershipModel({
    required this.partnershipList,
  }) : super(
    partnership: partnershipList
  );

  factory PartnershipModel.fromJson(Map<String, dynamic> json) => PartnershipModel(
    partnershipList: List<PartnershipData>.from(json["result"].map((x) => PartnershipData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(partnershipList.map((x) => x.toJson())),
  };
}

class PartnershipData extends Partnership{
  String name;
  String id;
  String label;
  String searchText;
  String value;
  bool? isCheck;

  PartnershipData({
    required this.name,
    required this.id,
    required this.label,
    required this.searchText,
    required this.value,
    this.isCheck,
  }) : super(
    name: name,
    id: id,
    label: label,
    searchText: searchText,
    value: value,
    isCheck: isCheck,
  );

  factory PartnershipData.fromJson(Map<String, dynamic> json) => PartnershipData(
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
