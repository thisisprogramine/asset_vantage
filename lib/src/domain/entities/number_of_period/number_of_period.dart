
import 'package:equatable/equatable.dart';

class NumberOfPeriodEntity extends Equatable{
  final List<NumberOfPeriodItemData> periodList;

  const NumberOfPeriodEntity({
    required this.periodList
  });

  @override
  List<Object?> get props => [periodList];
}

class NumberOfPeriodItemData extends Equatable{
  const NumberOfPeriodItemData({
    this.id,
    this.value,
    this.name,
  });

  final String? id;
  final int? value;
  final String? name;

  @override
  List<Object?> get props => [id, value, name];

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "value": value,
    "name": name,
  };
}