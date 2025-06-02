
import 'package:asset_vantage/src/domain/params/chatParams.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SendChatMessage extends UseCase<void, ChatParams?> {
  final AVRepository _avRepository;

  SendChatMessage(this._avRepository);

  @override
  Future<Either<AppError, void>> call(ChatParams? params) async =>
      _avRepository.sendMessage(question: params?.question,chatDataSource: params?.chatDataSource, entityId: params?.entityId, entityType: params?.entityType,);
}
