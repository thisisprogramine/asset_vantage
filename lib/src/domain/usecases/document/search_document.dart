import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/document/document_entity.dart';
import '../../params/document/search_document_params.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class SearchDocuments extends UseCase<DocumentEntity, SearchDocumentParams> {
  final AVRepository _avRepository;

  SearchDocuments(this._avRepository);

  @override
  Future<Either<AppError, DocumentEntity>> call(SearchDocumentParams params) async =>
      _avRepository.searchDocuments(context: params.context, requestBody: params.toJson());
}
