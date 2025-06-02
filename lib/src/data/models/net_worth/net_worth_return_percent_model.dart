import '../../../domain/entities/net_worth/net_worth_return_percent_entity.dart';

class NetWorthReturnPercentModel extends NetWorthReturnPercentEntity {
  NetWorthReturnPercentModel({
    this.allReturnPercentList,
  }) : super(returnPercentList: allReturnPercentList ?? []);

  final List<ReturnPercentItem>? allReturnPercentList;

  factory NetWorthReturnPercentModel.fromJson(Map<dynamic, dynamic> json) {
    return NetWorthReturnPercentModel(
        allReturnPercentList: json["result"] == null
            ? []
            : List<ReturnPercentItem>.from(
                json["result"]!.map((x) => ReturnPercentItem.fromJson(x))));
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "result": returnPercentList == null
          ? []
          : List<Map<dynamic, dynamic>>.from(
              returnPercentList!.map((x) => x.toJson())),
    };
  }
}

class ReturnPercentItem extends ReturnPercentItemData {
  const ReturnPercentItem({
    this.id,
    this.value,
    this.name,
  }) : super(id: id, value: value, name: name);

  final String? id;
  final int? value;
  final String? name;

  factory ReturnPercentItem.fromJson(Map<dynamic, dynamic> json) =>
      ReturnPercentItem(
        id: json["id"],
        value: json["value"],
        name: json["name"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "value": value,
        "name": name,
      };
}
