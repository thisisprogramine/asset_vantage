
class PartnershipEntity {
  List<Partnership> partnership;

  PartnershipEntity({
    required this.partnership,
  });

  factory PartnershipEntity.fromJson(Map<String, dynamic> json) => PartnershipEntity(
    partnership: List<Partnership>.from(json["result"].map((x) => Partnership.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(partnership.map((x) => x.toJson())),
  };
}

class Partnership {
  String name;
  String id;
  String label;
  String searchText;
  String value;
  bool? isCheck;

  Partnership({
    required this.name,
    required this.id,
    required this.label,
    required this.searchText,
    required this.value,
    this.isCheck,
  });

  factory Partnership.fromJson(Map<String, dynamic> json) => Partnership(
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
