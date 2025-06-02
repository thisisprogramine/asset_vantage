import 'package:asset_vantage/src/data/models/authentication/credentials.dart';
import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/repositories/authentication_repository.dart';
import 'package:asset_vantage/src/domain/repositories/av_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/authentication/get_user_data_params.dart';
import '../usecase.dart';

class SaveCredentials {
  final AuthenticationRepository _authenticationRepository;

  SaveCredentials(this._authenticationRepository);

  Future<void> call(Credentials params) async =>
      await _authenticationRepository.saveCredential(credentials: params.toJson());
}
