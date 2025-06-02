import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';

class HoldingMethodModel extends HoldingMethodEntities{
  final List<HoldingMethodItem>? holdingMethodItemList;

  HoldingMethodModel({ required this.holdingMethodItemList}): super(
    holdingMethodList: holdingMethodItemList ?? []
  );

  factory HoldingMethodModel.fromJson(Map<dynamic,dynamic> json){
    return HoldingMethodModel(
        holdingMethodItemList: json["result"] == null ? []: List<HoldingMethodItem>.from(json["result"]!.map((x)=>HoldingMethodItem.fromJson(x))));
  }

  Map<dynamic,dynamic> toJson(){
    return{
      "result": holdingMethodItemList == null ? [] : List<Map<dynamic,dynamic>>.from(holdingMethodItemList!.map((x)=>x.toJson()))
    };
  }

}

class HoldingMethodItem extends HoldingMethodItemData{
  final String? id;
  final String? name;
  final String? value;

  const HoldingMethodItem({
     this.id,  this.name,  this.value}):super(
    id: id,
    name: name,
    value: value
  );

  factory HoldingMethodItem.fromJson(Map<dynamic,dynamic> json) => HoldingMethodItem(
    id: json["id"],
    name: json["name"],
    value: json["value"]
  );

  Map<dynamic,dynamic> toJson()=>{
    "id": id,
    "name":name,
    "value":value
  };
}