import 'package:equatable/equatable.dart';

class InvestmentPolicyStatementPoliciesEntity extends Equatable{
  final List<Policies> policyList;

  const InvestmentPolicyStatementPoliciesEntity({
    required this.policyList,
  });

  @override
  List<Object?> get props => [policyList];
}

class Policies extends Equatable{
  final int? id;
  final String? policyname;

  const Policies({
    required this.id,
    required this.policyname
  });

  @override
  List<Object?> get props => [id, policyname];

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "Policyname": policyname,
  };
}