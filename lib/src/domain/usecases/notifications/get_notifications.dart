import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/notification/notification_entity.dart';
import '../usecase.dart';

class GetNotifications extends UseCase<NotificationsEntity, NoParams> {
  final AVRepository _avRepository;

  GetNotifications(this._avRepository);

  @override
  Future<Either<AppError, NotificationsEntity>> call(NoParams params) async =>
      _avRepository.getNotifications(requestBody: {});
}
