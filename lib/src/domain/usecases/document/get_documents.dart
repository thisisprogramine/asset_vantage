import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/document/document_entity.dart';
import '../../params/document/document_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetDocuments extends UseCase<DocumentEntity, DocumentParams> {
  final AVRepository _avRepository;

  GetDocuments(this._avRepository);

  @override
  Future<Either<AppError, DocumentEntity>> call(DocumentParams params) async =>
      _avRepository.getDocuments(context: params.context, requestBody: params.toJson());
}
