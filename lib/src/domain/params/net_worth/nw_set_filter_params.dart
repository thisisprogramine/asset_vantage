class SaveNWFilterParams{
  final String? tileName;
  final String? entityName;
  final String? grouping;
  final Object? filter;

  const SaveNWFilterParams({
    this.entityName,
    this.grouping,
    required this.filter,
    required this.tileName,
  });
}