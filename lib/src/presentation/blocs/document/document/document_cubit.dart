
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/usecases/document/get_documents.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/document/document_entity.dart';
import '../../../../domain/params/document/document_params.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'document_state.dart';

class DocumentCubit
    extends Cubit<DocumentState> {
  final GetDocuments getDocuments;
  final LoginCheckCubit loginCheckCubit;

  DocumentCubit({
    required this.getDocuments,
    required this.loginCheckCubit,
  }): super(DocumentInitial());

  void loadDocument({required BuildContext context, EntityData? selectedEntity, required String limit, required String startFrom}) async {

    emit(DocumentLoading());

    final Either<AppError, DocumentEntity> eitherDocument = await getDocuments(
        DocumentParams(
          context: context,
          entity: selectedEntity?.name,
          entitytype: selectedEntity?.type,
          id: selectedEntity?.id.toString(),
          limit: '5000',
          startfrom: '0',
        )
    );

    eitherDocument.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(DocumentError(errorType: error.appErrorType));
    }, (document) {
      emit(DocumentLoaded(documents: document.documents ?? []));
    });
  }
}
