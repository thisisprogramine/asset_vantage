

import '../../../domain/entities/number_of_period/number_of_period.dart';

class NumberOfPeriodModel extends NumberOfPeriodEntity {
  NumberOfPeriodModel({
    this.numberOfPeriodList,
  }) : super(
      periodList: numberOfPeriodList ?? []
  );

  final List<NumberOfPeriodItem>? numberOfPeriodList;

  factory NumberOfPeriodModel.fromJson(Map<dynamic, dynamic> json) {
    return NumberOfPeriodModel(
        numberOfPeriodList: json["result"] == null ? [] : List<NumberOfPeriodItem>.from(json["result"]!.map((x) => NumberOfPeriodItem.fromJson(x))));
  }

  Map<dynamic, dynamic> toJson() {

    return {
      "result": numberOfPeriodList == null ? [] : List<Map<dynamic, dynamic>>.from(numberOfPeriodList!.map((x) => x.toJson())),
    };
  }
}

class NumberOfPeriodItem extends NumberOfPeriodItemData {
  const NumberOfPeriodItem({
    this.id,
    this.value,
    this.name,
  }) : super(
      id: id,
      value: value,
      name: name
  );

  final String? id;
  final int? value;
  final String? name;

  factory NumberOfPeriodItem.fromJson(Map<dynamic, dynamic> json) => NumberOfPeriodItem(
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

