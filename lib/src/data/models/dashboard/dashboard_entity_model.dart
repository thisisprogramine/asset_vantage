// import '../../../domain/entities/dashboard/dashboard_list_entity.dart';

import '../../../domain/entities/dashboard/dashboard_list_entity.dart';

class DashboardEntityModel extends DashboardEntity{
  List<Entity>? entityList;

  DashboardEntityModel({
    this.entityList
  }) : super(list: entityList);

  factory DashboardEntityModel.fromJson(Map<dynamic, dynamic> json) {
    return DashboardEntityModel(
        entityList: json['EntityList'] != null ? json["EntityList"] != null ? List<Entity>.from(
            json['EntityList']!.map((x) {
              return Entity.fromJson(x);
            })
        ) : [] : []
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'EntityList': entityList == null ? [] : List<Map<dynamic, dynamic>>.from(entityList!.map((x) => x.toJson())),
    };
  }

}

class Entity extends EntityData{
  final int? id;
  final String? name;
  final String? type;
  final String? currency;
  final String? accountingyear;

  Entity(
      {
        this.id,
        this.name,
        this.type,
        this.currency,
        this.accountingyear,
      }) : super(
    id: id,
    name: name,
    type: type,
    currency: currency,
    accountingyear: accountingyear,
  );

  factory Entity.fromJson(Map<dynamic, dynamic> json) {

    return Entity(
      id: json['id'] != null ? json['id']! : null,
      name: json['name'] != null ? json['name']! : null,
      type: json['type'] != null ? json['type']! : null,
      currency: json['currency'] != null ? json['currency']! : null,
      accountingyear: json['accountingYear'] != null ? json['accountingYear']! : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id != null ? id! : null,
      'name': name != null ? name! : null,
      'type': type != null ? type! : null,
      'currency': currency != null ? currency! : null,
      'accountingYear': accountingyear != null ? accountingyear! : null,
    };
  }
}