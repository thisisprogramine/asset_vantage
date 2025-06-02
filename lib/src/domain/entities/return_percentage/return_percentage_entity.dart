
import 'package:equatable/equatable.dart';

import '../../../data/models/return_percentage/return_percentage_model.dart';

class ReturnPercentEntity extends Equatable{
  List<ReturnPercentItemData?> returnPercentList;

  ReturnPercentEntity({
    required this.returnPercentList
  });

  @override
  List<Object?> get props => [returnPercentList];
}

class ReturnPercentItemData extends Equatable{
  const ReturnPercentItemData({
    this.id,
    required this.value,
    this.key,
    this.name,
  });

  final String? id;
  final ReturnType value;
  final String? key;
  final String? name;

  @override
  List<Object?> get props => [id, value, key, name];

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "value": value,
    "key": key,
    "name": name,
  };
}