import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../entities/dashboard/dashboard_list_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetDashboardEntityListData extends UseCase<DashboardEntity, BuildContext> {
  final AVRepository _avRepository;

  GetDashboardEntityListData(this._avRepository);

  @override
  Future<Either<AppError, DashboardEntity>> call(BuildContext context) async =>
      _avRepository.getEntities(context: context);
}
