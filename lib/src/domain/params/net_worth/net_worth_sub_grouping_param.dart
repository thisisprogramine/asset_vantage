class NetWorthSubGroupingParams{
  final String? entity;
  final String? id;
  final String? entitytype;
  final String? subgrouping;
  final String? todate;

  const NetWorthSubGroupingParams({
    this.entity,
    this.id,
    this.entitytype,
    this.subgrouping,
    this.todate,
  });

  Map<String, dynamic> toJson() {
    return {
      "entity": entity != null ? entity! : '',
      "id": id != null ? id! : '',
      "entitytype": entitytype != null ? entitytype! : '',
      "subgrouping": subgrouping != null ? subgrouping! : '',
      "todate": todate != null ? todate! : ''
    };
  }
}