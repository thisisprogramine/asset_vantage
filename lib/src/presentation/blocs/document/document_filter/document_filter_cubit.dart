
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/usecases/dashboard/get_dashboard_entity_list.dart';
import '../../../../domain/usecases/document/get_selected_document_entity.dart';
import '../../../../domain/usecases/document/save_selected_document_entity.dart';
import '../document/document_cubit.dart';


part 'document_filter_state.dart';

class DocumentFilterCubit extends Cubit<DocumentFilterState> {
  final DocumentCubit documentCubit;
  final GetDashboardEntityListData getDashboardEntityListData;
  final GetSelectedDocumentEntity getSelectedDocumentEntity;
  final SaveSelectedDocumentEntity saveSelectedDocumentEntity;

  DocumentFilterCubit({
    required this.documentCubit,
    required this.getDashboardEntityListData,
    required this.getSelectedDocumentEntity,
    required this.saveSelectedDocumentEntity
  }) : super(const DocumentFilterInitial());

  void loadDocumentEntities({required BuildContext context}) async{

    emit(DocumentFilterLoading());

    final Either<AppError, DashboardEntity> eiterEntityList = await getDashboardEntityListData(context);
    final entity = await getSelectedEntity();
    eiterEntityList.fold((error) {
      emit(DocumentFilterError(error.message,error.appErrorType));
    }, (entityList) {
      List<EntityData>? temp;
      if(entity!=null){
        final index = entityList.list?.indexWhere((element) => element.id==entity.id && element.type==entity.type);
        temp = [...(entityList.list ?? [])];
        if(index!=null && index!=-1){
          temp.removeAt(index);
          temp.insert(0, Entity.fromJson(entity.toJson()));
        }
      }
      emit(DocumentFilterChanged(
        origList: entityList.list,
        list: temp ?? entityList.list,
        selectFilter: temp!=null && temp.isNotEmpty?temp.first:entityList.list?.first,
      )
      );
      documentCubit.loadDocument(context: context, selectedEntity: temp!=null && temp.isNotEmpty?temp.first:entityList.list?.first, limit: '50', startFrom: '0');
    });
  }

  void selectDocumentEntity({required BuildContext context, EntityData? entity}) async{

    emit(DocumentFilterInitial(
        origList: state.originalList,
        list: state.filterList,
        selectFilter: state.selectedFilter
    ));
    saveSelectedEntity(entity:entity);
    final index = state.originalList?.indexWhere((element) => element.id==entity?.id && element.type==entity?.type);
    List<EntityData>? temp = [...(state.originalList ?? [])];
    if(index!=null && index!=-1){
      temp.removeAt(index);
      if(entity!=null){
        temp.insert(0, entity);
      }
    }

    emit(DocumentFilterChanged(
        origList: state.originalList,
        list: temp.isNotEmpty?temp: state.filterList,
        selectFilter: entity
    )
    );

    documentCubit.loadDocument(context: context, selectedEntity: entity, limit: '50', startFrom: '0');
  }

  Future<EntityData?> getSelectedEntity() async {
    final Either<AppError, EntityData?> selectedEntity = await getSelectedDocumentEntity(NoParams());

    return selectedEntity.fold((error) {

      return null;
    }, (widget) {
      return widget;
    });
  }

  void saveSelectedEntity({required EntityData? entity}) async {
    final Either<AppError, void> saveSelectedEntity = await saveSelectedDocumentEntity(entity);

    saveSelectedEntity.fold((error) {

    }, (widget) {

    });
  }

}
