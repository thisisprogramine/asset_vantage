


import '../../../domain/entities/performance/performance_secondary_grouping_entity.dart';

class PerformanceSecondaryGroupingModel extends PerformanceSecondaryGroupingEntity{
  PerformanceSecondaryGroupingModel({
    this.secondaryGrouping,
  }) : super(
    grouping: secondaryGrouping ?? [],
  );

  final List<SecondaryGrouping>? secondaryGrouping;

  factory PerformanceSecondaryGroupingModel.fromJson(Map<dynamic, dynamic> json) {
    final List<SecondaryGrouping> list = json["result"] == null ? [] : List<SecondaryGrouping>.from(
        json["result"]!.map(
                (x) {
              return SecondaryGrouping.fromJson(x);
            }
        )
    );

    for(int i = 0; i < list.length; i++) {
      final SecondaryGrouping g = list[i];
      if(g.name == 'Strategy') {
        list.removeAt(i);
        list.insert(0, g);
      }
    }

    return PerformanceSecondaryGroupingModel(
      secondaryGrouping: list
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "result": secondaryGrouping == null ? [] : List<dynamic>.from(secondaryGrouping!.map((x) => x.toJson())),
  };
}

class SecondaryGrouping extends GroupingEntity {
  const SecondaryGrouping({
    this.id,
    this.name,
  }) : super(
    id: id,
    name: name,
  );

  final String? id;
  final String? name;

  factory SecondaryGrouping.fromJson(Map<dynamic, dynamic> json) => SecondaryGrouping(
    id: json["id"] != null ? json["id"]! : null,
    name: json["name"] != null ? json["name"]! : null,
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
