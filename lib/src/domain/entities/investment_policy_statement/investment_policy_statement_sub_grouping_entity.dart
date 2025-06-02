
import 'package:equatable/equatable.dart';

class InvestmentPolicyStatementSubGroupingEntity extends Equatable{
  final List<SubGroupingItemData> subGroupingList;

  const InvestmentPolicyStatementSubGroupingEntity({
    required this.subGroupingList
  });

  @override
  List<Object?> get props => [subGroupingList];
}

class SubGroupingItemData extends Equatable{
  const SubGroupingItemData({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  @override
  List<Object?> get props => [id, name];

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}