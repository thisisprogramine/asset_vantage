import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/currency/save_selected_currency_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SaveSelectedCurrency extends UseCase<void, SaveSelectedCurrencyParams> {
  final AVRepository _avRepository;

  SaveSelectedCurrency(this._avRepository);

  @override
  Future<Either<AppError, void>> call(SaveSelectedCurrencyParams params) async =>
      _avRepository.saveCurrencyFilter(currency: params.currency, tileName: params.tileName);
}
