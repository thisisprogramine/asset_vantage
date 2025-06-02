
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../params/chatParams.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class ChatStream extends UseCase<void, EstablishStreamParams> {
  final AVRepository _avRepository;

  ChatStream(this._avRepository);

  @override
  Future<Either<AppError, void>> call(EstablishStreamParams params) async =>
      _avRepository.establishChatStream(authToken: params.authToken,subId: params.subId,chatDataSource: params.chatDataSource,);
}