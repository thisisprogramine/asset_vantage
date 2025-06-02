
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';

class InvestmentPolicyStatementGroupingModel extends InvestmentPolicyStatementGroupingEntity{
  InvestmentPolicyStatementGroupingModel({
    this.primaryGrouping,
  }) : super(
    groupingList: primaryGrouping ?? []
  );

  final List<PrimaryGrouping>? primaryGrouping;

  factory InvestmentPolicyStatementGroupingModel.fromJson(Map<dynamic, dynamic> json) {
    List<PrimaryGrouping> list = json["result"] == null ? [] : List<PrimaryGrouping>.from(
        json["result"]!.map(
                (x) {
              return x['name'] == 'Advisor' || x['name'] == 'Asset-Class' || x['name'] == 'Currency' || x['name'] == 'Liquidity' || x['name'] == 'Strategy' ? PrimaryGrouping.fromJson(x) : PrimaryGrouping.fromJson({});
            }
        )
    )..removeWhere((value) => value.id == null);

    for(int i = 0; i < list.length; i++) {
      final PrimaryGrouping g = list[i];
      if(g.name == 'Asset-Class') {
        list.removeAt(i);
        list.insert(0, g);
      }
    }

    return InvestmentPolicyStatementGroupingModel(
      primaryGrouping: list
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "result": primaryGrouping == null ? [] : List<dynamic>.from(primaryGrouping!.map((x) => x.toJson())),
  };
}

class PrimaryGrouping extends Grouping {
  const PrimaryGrouping({
    this.id,
    this.name,
  }) : super(
    id: id,
    name: name,
  );

  final int? id;
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


