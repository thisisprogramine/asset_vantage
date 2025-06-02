
import 'package:equatable/equatable.dart';

class NetWorthReturnPercentEntity extends Equatable{
  final List<ReturnPercentItemData> returnPercentList;

  const NetWorthReturnPercentEntity({
    required this.returnPercentList
  });

  @override
  List<Object?> get props => [returnPercentList];
}

class ReturnPercentItemData extends Equatable{
  const ReturnPercentItemData({
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