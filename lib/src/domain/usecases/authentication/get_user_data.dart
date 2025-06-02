import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/authentication/get_user_data_params.dart';
import '../usecase.dart';

class GetUserData extends UseCase<UserEntity, GetUserDataParams> {
  final AVRepository _avRepository;

  GetUserData(this._avRepository);

  @override
  Future<Either<AppError, UserEntity>> call(GetUserDataParams params) async =>
      _avRepository.getUserData(context: params.context, requestBody: params.toJson());
}
