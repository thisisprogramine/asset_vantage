import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';

class PartnershipMethodModel extends PartnershipMethodEntities{
  final List<PartnershipMethodItem>? partnershipMethodItemList;

  PartnershipMethodModel({ required this.partnershipMethodItemList}):super(
     partnershipMethodList: partnershipMethodItemList ?? []
  );

  factory PartnershipMethodModel.fromJson(Map<dynamic,dynamic> json){
    return PartnershipMethodModel(
        partnershipMethodItemList: json["result"] == null ? [] : List<PartnershipMethodItem>.from(json["result"]!.map((x)=> PartnershipMethodItem.fromJson(x))));
  }

  Map<dynamic,dynamic> toJson(){
    return {
      "result": partnershipMethodItemList == null ? [] : List<Map<dynamic,dynamic>>.from(partnershipMethodItemList!.map((x)=>x.toJson()))
    };
  }


}

class PartnershipMethodItem extends PartnershipMethodItemData{
  final String? id;
  final String? name;
  final String? value;

   PartnershipMethodItem({this.id,  this.name, this.value}): super(
    id: id,
    name: name,
    value: value
  );

  factory PartnershipMethodItem.fromJson(Map<dynamic,dynamic> json)=> PartnershipMethodItem(
    id: json["id"],
    name: json["name"],
    value: json["value"]
  );

  Map<dynamic,dynamic> toJson() => {
    "id": id,
    "name": name,
    "value": value,
  };

}