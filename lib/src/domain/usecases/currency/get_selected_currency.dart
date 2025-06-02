import 'package:asset_vantage/src/domain/params/currency/get_selected_currency_params.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/currency/currency_model.dart';
import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetSelectedCurrency extends UseCase<CurrencyData?, GetSelectedCurrencyParams> {
  final AVRepository _avRepository;

  GetSelectedCurrency(this._avRepository);

  @override
  Future<Either<AppError, CurrencyData?>> call(GetSelectedCurrencyParams params) async =>
      _avRepository.getSavedCurrencyFilter(tileName: params.tileName);
}
