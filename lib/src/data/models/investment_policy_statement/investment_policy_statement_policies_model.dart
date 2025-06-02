
import '../../../domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';

class InvestmentPolicyStatementPoliciesModel extends InvestmentPolicyStatementPoliciesEntity{
  InvestmentPolicyStatementPoliciesModel({
    this.result,
  }) : super(
    policyList: result ?? []
  );

  final List<PolicyModel>? result;

  factory InvestmentPolicyStatementPoliciesModel.fromJson(Map<dynamic, dynamic> json) => InvestmentPolicyStatementPoliciesModel(
    result: json["result"] == null ? [] : List<PolicyModel>.from(json["result"]!.map((x) => PolicyModel.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class PolicyModel extends Policies{
  PolicyModel({
    this.id,
    this.policyname,
  }) : super(
    id: id,
      policyname: policyname
  );

  final int? id;
  final String? policyname;

  factory PolicyModel.fromJson(Map<dynamic, dynamic> json) => PolicyModel(
    id: json["id"],
    policyname: json["Policyname"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "Policyname": policyname,
  };
}
