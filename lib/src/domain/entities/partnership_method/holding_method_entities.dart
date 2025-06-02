import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class HoldingMethodEntities extends Equatable{
  final List<HoldingMethodItemData> holdingMethodList;

  const HoldingMethodEntities({required this.holdingMethodList});

  @override
  List<Object?> get props => [holdingMethodList];

}
class HoldingMethodItemData extends Equatable{
  final String? id;
  final String? value;
  final String? name;

  const HoldingMethodItemData({
     this.id,  this.value,  this.name});

  @override
  List<Object?> get props => [id,value,name];

  Map<dynamic,dynamic> toJson() =>{
    "id": id,
    "value": value,
    "name":name
  };

}