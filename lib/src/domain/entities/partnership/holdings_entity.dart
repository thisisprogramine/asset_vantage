
class HoldingsEntity {
  List<Holding> holding;

  HoldingsEntity({
    required this.holding,
  });

  factory HoldingsEntity.fromJson(Map<String, dynamic> json) => HoldingsEntity(
    holding: List<Holding>.from(json["result"].map((x) => Holding.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(holding.map((x) => x.toJson())),
  };
}

class Holding {
  String name;
  String id;
  String label;
  String searchText;
  String value;
  bool? isCheck;

  Holding({
    required this.name,
    required this.id,
    required this.label,
    required this.searchText,
    required this.value,
    this.isCheck,
  });

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
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
