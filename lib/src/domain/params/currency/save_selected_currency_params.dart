import '../../entities/currency/currency_entity.dart';

class SaveSelectedCurrencyParams{
  final String? tileName;
  final Currency? currency;

  const SaveSelectedCurrencyParams({
    required this.tileName,
    required this.currency,
  });
}