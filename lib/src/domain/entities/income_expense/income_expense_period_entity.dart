
import 'package:equatable/equatable.dart';

class IncomeExpensePeriodEntity extends Equatable{
  final List<PeriodItemData> periodList;

  const IncomeExpensePeriodEntity({
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

}