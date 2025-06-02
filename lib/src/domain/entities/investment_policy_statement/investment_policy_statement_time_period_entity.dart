
import 'package:equatable/equatable.dart';

class InvestmentPolicyStatementTimePeriodEntity extends Equatable{
  final List<TimePeriodItemData>? timePeriodList;

  const InvestmentPolicyStatementTimePeriodEntity({
    this.timePeriodList
  });

  @override
  List<Object?> get props => [];
}

class TimePeriodItemData extends Equatable{
  const TimePeriodItemData({
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