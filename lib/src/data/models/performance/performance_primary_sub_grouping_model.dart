
import '../../../domain/entities/performance/performance_primary_sub_grouping_enity.dart';

class PerformancePrimarySubGroupingModel extends PerformancePrimarySubGroupingEntity {
  PerformancePrimarySubGroupingModel({
    this.subGrouping,
  }) : super(
      subGroupingList: subGrouping ?? []
  );

  final List<SubGroupingItem?>? subGrouping;

  factory PerformancePrimarySubGroupingModel.fromJson(Map<dynamic, dynamic> json) {
    return PerformancePrimarySubGroupingModel(
      subGrouping: (json["result"] is List)
          ? (json["result"] as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "result": subGrouping == null
          ? []
          : subGrouping!.where((x) => x != null).map((x) => x!.toJson()).toList(),
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

