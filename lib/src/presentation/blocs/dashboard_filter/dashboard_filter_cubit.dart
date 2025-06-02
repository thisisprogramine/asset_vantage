
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/dashboard/get_dashboard_entity_list.dart';
import '../../../domain/usecases/dashboard/get_selected_dashboard_entity.dart';
import '../../../domain/usecases/dashboard/save_selected_dashboard_entity.dart';

part 'dashboard_filter_state.dart';

class DashboardFilterCubit extends Cubit<DashboardFilterState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final SaveSelectedDashboardEntity saveSelectedDashboardEntity;
  final GetSelectedDashboardEntity getSelectedDashboardEntity;

  DashboardFilterCubit({
    required this.getDashboardEntityListData,
    required this.saveSelectedDashboardEntity,
    required this.getSelectedDashboardEntity,
  }) : super(const DashboardFilterInitial());

  Future<void> loadDashboardEntities({required BuildContext context}) async{

    emit(DashboardFilterLoading());

    final Either<AppError, DashboardEntity> eiterEntityList = await getDashboardEntityListData(context);

    final entity = await getSelectedEntity();

    eiterEntityList.fold((error) {
      emit(DashboardFilterError(error.message, error.appErrorType));
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
      emit(DashboardFilterChanged(
          origList: entityList.list,
          list: temp ?? entityList.list,
          selectFilter: temp!=null && temp.isNotEmpty?temp.first:entityList.list?.first,
        )
      );

    });
  }

  Future<void> selectDashboardEntity({EntityData? entity}) async{

    emit(DashboardFilterInitial(
        origList: state.originalList,
        list: state.filterList,
        selectFilter: state.selectedFilter
    ));
    saveSelectedEntity(entity:entity);
    final index = state.originalList?.indexWhere((element) => element.id==entity?.id && element.type==entity?.type);
    List<EntityData>? temp = [...(state.originalList ?? [])];
    if(index!=null && index!=-1) {
      temp.removeAt(index);
      if(entity!=null) {
        temp.insert(0, entity);
      }
    }
    emit(DashboardFilterChanged(
        origList: state.originalList,
        list: temp.isNotEmpty?temp: state.filterList,
        selectFilter: entity
      )
    );
  }

  Future<EntityData?> getSelectedEntity() async {
    final Either<AppError, EntityData?> selectedEntity = await getSelectedDashboardEntity(NoParams());

    return selectedEntity.fold((error) {
      return null;
    }, (widget) {
      return widget;
    });
  }

  void saveSelectedEntity({required EntityData? entity}) async {
    final Either<AppError, void> saveSelectedEntity = await saveSelectedDashboardEntity(entity);

    saveSelectedEntity.fold((error) {

    }, (widget) {

    });
  }
}
