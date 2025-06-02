import 'package:asset_vantage/src/domain/entities/denomination/denomination_entity.dart';

class SaveDenominationFilterParams{
  final String? tileName;
  final DenominationData? filter;

  const SaveDenominationFilterParams({
    required this.tileName,
    required this.filter,
  });
}