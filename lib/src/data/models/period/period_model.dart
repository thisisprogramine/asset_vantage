
import '../../../domain/entities/period/period_enitity.dart';

class PeriodModel extends PeriodEntity {
  PeriodModel({
    this.period,
  }) : super(
      periodList: period ?? []
  );

  final List<PeriodItem>? period;

  factory PeriodModel.fromJson(Map<dynamic, dynamic> json) {
    return PeriodModel(
        period: json["result"] == null ? [] : List<PeriodItem>.from(json["result"]!.map((x) => PeriodItem.fromJson(x))));
  }

  Map<dynamic, dynamic> toJson() {

    return {
      "result": period == null ? [] : List<Map<dynamic, dynamic>>.from(period!.map((x) => x.toJson())),
    };
  }
}

class PeriodItem extends PeriodItemData {
  const PeriodItem({
    this.id,
    this.gaps,
    this.name,
  }) : super(
      id: id,
      name: name
  );

  final String? id;
  final int? gaps;
  final String? name;

  factory PeriodItem.fromJson(Map<dynamic, dynamic> json) => PeriodItem(
    id: json["id"],
    gaps: json["gaps"],
    name: json["name"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "gaps": gaps,
    "name": name,
  };
}

