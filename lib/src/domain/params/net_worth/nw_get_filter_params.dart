class GetNWFilterParams{
  final String? tileName;
  final String? entityName;
  final String? grouping;

  const GetNWFilterParams({
    required this.tileName,
    this.grouping,
    this.entityName,
  });
}