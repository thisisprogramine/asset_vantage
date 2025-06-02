
import 'package:equatable/equatable.dart';

class CashBalanceSubGroupingEntity extends Equatable{
  List<SubGroupingItemData?> subGroupingList;

  CashBalanceSubGroupingEntity({
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

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  List<Object?> get props => [id, name];

}