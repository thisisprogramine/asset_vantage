class NetWorthGroupingEntity {
  NetWorthGroupingEntity({
    required this.grouping,
  });

  final List<GroupingEntity> grouping;
}

class GroupingEntity {
  const GroupingEntity({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

}