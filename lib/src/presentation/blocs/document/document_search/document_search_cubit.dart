
import 'package:asset_vantage/src/domain/params/document/search_document_params.dart';
import 'package:asset_vantage/src/domain/usecases/document/search_document.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/document/document_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'document_search_state.dart';

class DocumentSearchCubit extends Cubit<DocumentSearchState> {
  final SearchDocuments searchDocuments;
  final LoginCheckCubit loginCheckCubit;

  DocumentSearchCubit({
    required this.searchDocuments,
    required this.loginCheckCubit,
  }) : super(DocumentSearchInitial());

  void searchDocument({required BuildContext context, EntityData? selectedEntity, required String query, required String limit, required String startFrom}) async {

    emit(DocumentSearchLoading());

    final Either<AppError, DocumentEntity> eitherDocument = await searchDocuments(
        SearchDocumentParams(
          context: context,
            entity: selectedEntity?.name ?? '',
            id: selectedEntity?.id.toString() ?? '',
            entitytype: selectedEntity?.type ?? '',
            searchstring: query,
            limit: "5000",
            startfrom: "0"
        )
    );

    eitherDocument.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(DocumentSearchError(errorType: error.appErrorType));
    }, (document) {
      emit(DocumentSearchLoaded(documents: document.documents ?? []));
    });
  }

}
