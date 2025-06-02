


import '../../../domain/entities/performance/performance_primary_grouping_entity.dart';

class PerformancePrimaryGroupingModel extends PerformancePrimaryGroupingEntity{
  PerformancePrimaryGroupingModel({
    this.primaryGrouping,
  }) : super(
    grouping: primaryGrouping ?? [],
  );

  final List<PrimaryGrouping>? primaryGrouping;

  factory PerformancePrimaryGroupingModel.fromJson(Map<dynamic, dynamic> json) {
    final List<PrimaryGrouping> list = json["result"] == null ? [] : List<PrimaryGrouping>.from(
        json["result"]!.map(
                (x) {
              return PrimaryGrouping.fromJson(x);
            }
        )
    );

    for(int i = 0; i < list.length; i++) {
      final PrimaryGrouping g = list[i];
      if(g.name == 'Asset-Class') {
        list.removeAt(i);
        list.insert(0, g);
      }
    }

    return PerformancePrimaryGroupingModel(
      primaryGrouping: list
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "result": primaryGrouping == null ? [] : List<dynamic>.from(primaryGrouping!.map((x) => x.toJson())),
  };
}

class PrimaryGrouping extends GroupingEntity {
  const PrimaryGrouping({
    this.id,
    this.name,
  }) : super(
    id: id,
    name: name,
  );

  final String? id;
  final String? name;

  factory PrimaryGrouping.fromJson(Map<dynamic, dynamic> json) => PrimaryGrouping(
    id: json["id"] != null ? json["id"]! : null,
    name: json["name"] != null ? json["name"]! : null,
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
