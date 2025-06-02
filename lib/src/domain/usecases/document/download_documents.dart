import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/document/download_entity.dart';
import '../../params/document/download_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class DownloadDocuments extends UseCase<DownloadEntity, DownloadParams> {
  final AVRepository _avRepository;

  DownloadDocuments(this._avRepository);

  @override
  Future<Either<AppError, DownloadEntity>> call(DownloadParams params) async =>
      _avRepository.downloadDocuments(context: params.context, requestBody: params.toJson());
}
