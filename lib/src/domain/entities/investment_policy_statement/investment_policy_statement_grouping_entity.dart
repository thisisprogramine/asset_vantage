import 'package:equatable/equatable.dart';

class InvestmentPolicyStatementGroupingEntity extends Equatable{
  final List<Grouping> groupingList;

  const InvestmentPolicyStatementGroupingEntity({
    required this.groupingList,
  });

  @override
  List<Object?> get props => [groupingList];
}

class Grouping extends Equatable{
  final int? id;
  final String? name;

  const Grouping({
    required this.id,
    required this.name
  });

  @override
  List<Object?> get props => [id, name];
}