
import '../../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart';

class PerformanceSecondarySubGroupingModel extends PerformanceSecondarySubGroupingEntity {
  PerformanceSecondarySubGroupingModel({
    this.subGrouping,
  }) : super(
      subGroupingList: subGrouping ?? []
  );

  final List<SubGroupingItem>? subGrouping;

  factory PerformanceSecondarySubGroupingModel.fromJson(Map<dynamic, dynamic> json) {
    return PerformanceSecondarySubGroupingModel(
        subGrouping: json["result"] == null ? [] : List<SubGroupingItem>.from(json["result"]!.map((x) => SubGroupingItem.fromJson(x))));
  }

  Map<dynamic, dynamic> toJson() {

    return {
      "result": subGrouping == null ? [] : List<Map<dynamic, dynamic>>.from(subGrouping!.map((x) => x.toJson())),
    };
  }
}

class SubGroupingItem extends SubGroupingItemData {
  const SubGroupingItem({
    this.id,
    this.name,
  }) : super(
      id: id,
      name: name
  );

  final String? id;
  final String? name;

  factory SubGroupingItem.fromJson(Map<dynamic, dynamic> json) => SubGroupingItem(
    id: json["id"].toString(),
    name: json["name"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

