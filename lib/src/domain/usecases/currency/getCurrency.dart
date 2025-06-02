import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetCurrencies extends UseCase<CurrencyEntity, BuildContext> {
  final AVRepository _avRepository;

  GetCurrencies(this._avRepository);

  @override
  Future<Either<AppError, CurrencyEntity>> call(BuildContext context) async =>
      _avRepository.getCurrencies(context: context);
}
