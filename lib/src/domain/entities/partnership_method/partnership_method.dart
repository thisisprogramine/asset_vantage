import 'package:equatable/equatable.dart';

class PartnershipMethodEntities extends Equatable{
  final List<PartnershipMethodItemData> partnershipMethodList;

  const PartnershipMethodEntities({required this.partnershipMethodList});

  @override
  List<Object?> get props => [partnershipMethodList];

}

class PartnershipMethodItemData extends Equatable{
  final String? id;
  final String? value;
  final String? name;

  const PartnershipMethodItemData({this.id, this.value, this.name});

  @override
  List<Object?> get props => [id,value,name];

  Map<dynamic,dynamic> toJson() =>
      {
        "id":id,
        "value": value,
        "name": name
      };

}