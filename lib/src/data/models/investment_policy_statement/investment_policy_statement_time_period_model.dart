
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';

class InvestmentPolicyStatementTimePeriodModel extends InvestmentPolicyStatementTimePeriodEntity{
  const InvestmentPolicyStatementTimePeriodModel({
    this.timePeriod,
  }) : super(
    timePeriodList: timePeriod
  );

  final List<TimePeriodItem>? timePeriod;

  factory InvestmentPolicyStatementTimePeriodModel.fromJson(Map<dynamic, dynamic> json) => InvestmentPolicyStatementTimePeriodModel(
    timePeriod: json["result"] == null ? [] : List<TimePeriodItem>.from(json["result"]!.map((x) => TimePeriodItem.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "result": timePeriod == null ? [] : List<dynamic>.from(timePeriod!.map((x) => x.toJson())),
  };
}

class TimePeriodItem extends TimePeriodItemData {
  const TimePeriodItem({
    this.id,
    this.name,
  }) : super(
      id: id,
      name: name
  );

  final String? id;
  final String? name;

  factory TimePeriodItem.fromJson(Map<dynamic, dynamic> json) => TimePeriodItem(
    id: json["id"],
    name: json["name"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}


