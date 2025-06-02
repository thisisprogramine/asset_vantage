
import 'package:asset_vantage/src/domain/params/chatParams.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class ConnectServer extends UseCase<void, ChatConnectionParams> {
  final AVRepository _avRepository;

  ConnectServer(this._avRepository);

  @override
  Future<Either<AppError, void>> call(ChatConnectionParams? params) async =>
      _avRepository.connectChatServer(authToken: params?.authToken, subId: params?.subId,);
}