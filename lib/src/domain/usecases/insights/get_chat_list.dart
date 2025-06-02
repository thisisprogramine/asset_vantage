
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/insights/messages_model.dart';
import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetAllChats extends UseCase<List<ChatMsg>?, NoParams> {
  final AVRepository _avRepository;

  GetAllChats(this._avRepository);

  @override
  Future<Either<AppError, List<ChatMsg>?>> call(NoParams params) async =>
      _avRepository.getChatList();
}