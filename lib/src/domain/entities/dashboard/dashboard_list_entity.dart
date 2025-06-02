//

class DashboardEntity {
  List<EntityData>? list;

  DashboardEntity({
    this.list
  });
}

class EntityData {
  int? id;
  String? name;
  String? type;
  String? currency;
  String? accountingyear;

  EntityData({
    this.id,
    this.name,
    this.type,
    this.currency,
    this.accountingyear,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id != null ? id! : null,
      'name': name != null ? name! : null,
      'type': type != null ? type! : null,
      'currency': currency != null ? currency! : null,
      'accountingyear': accountingyear != null ? accountingyear! : null,
    };
  }
}