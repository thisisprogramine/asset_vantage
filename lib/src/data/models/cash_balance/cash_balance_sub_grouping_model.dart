

import '../../../domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart';

class CashBalanceSubGroupingModel extends CashBalanceSubGroupingEntity {
  CashBalanceSubGroupingModel({
    this.subGrouping,
  }) : super(
      subGroupingList: subGrouping ?? []
  );

  final List<SubGroupingItem>? subGrouping;

  factory CashBalanceSubGroupingModel.fromJson(Map<dynamic, dynamic> json) {
    return CashBalanceSubGroupingModel(
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
    id: json["id"],
    name: json["name"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

