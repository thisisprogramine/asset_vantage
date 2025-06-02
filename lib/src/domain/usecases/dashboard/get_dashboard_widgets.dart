import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../entities/dashboard/dashboard_widget_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetDashboardWidgetData extends UseCase<WidgetListEntity, BuildContext> {
  final AVRepository _avRepository;

  GetDashboardWidgetData(this._avRepository);

  @override
  Future<Either<AppError, WidgetListEntity>> call(BuildContext context) async =>
      _avRepository.getDashboardWidget(context: context, requestBody: {});
}
