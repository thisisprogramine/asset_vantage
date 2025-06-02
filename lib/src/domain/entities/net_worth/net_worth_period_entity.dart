import 'package:equatable/equatable.dart';

class NetWorthPeriodEntity extends Equatable{
  final List<PeriodItemData> periodList;

  const NetWorthPeriodEntity({
    required this.periodList
  });

  @override
  List<Object?> get props => [periodList];
}

class PeriodItemData extends Equatable{
  const PeriodItemData({
    this.id,
    this.gaps,
    this.name,
  });

  final String? id;
  final int? gaps;
  final String? name;

  @override
  List<Object?> get props => [id, gaps, name];

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "gaps": gaps,
    "name": name,
  };

}