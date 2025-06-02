class PerformanceSecondaryGroupingEntity{
  PerformanceSecondaryGroupingEntity({
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

}