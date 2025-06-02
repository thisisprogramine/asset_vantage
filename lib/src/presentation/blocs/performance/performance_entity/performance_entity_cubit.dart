import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/domain/usecases/dashboard/get_dashboard_entity_list.dart';
import 'package:asset_vantage/src/domain/usecases/performance/performance_filter/selected_entity/get_performance_selected_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_entity/save_performance_selected_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'performance_entity_state.dart';

class PerformanceEntityCubit extends Cubit<PerformanceEntityState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final GetPerformanceSelectedEntity getPerformanceSelectedEntity;
  final SavePerformanceSelectedEntity savePerformanceSelectedEntity;
  final LoginCheckCubit loginCheckCubit;


  PerformanceEntityCubit({
    required this.getDashboardEntityListData,
    required this.getPerformanceSelectedEntity,
    required this.savePerformanceSelectedEntity,
    required this.loginCheckCubit,
  })
      : super(PerformanceEntityInitial());

  Future<void> loadPerformanceEntity({required BuildContext context, bool shouldClearData = false, Entity? favoriteEntity}) async {
    emit(const PerformanceEntityLoading());

    final Either<AppError, DashboardEntity> eitherDashboardEntityListData = await getDashboardEntityListData(context);
    final Entity? savedEntity = favoriteEntity ?? await getPerformanceSelectedEntity();
    
    eitherDashboardEntityListData.fold(
      (error) {

        return emit(PerformanceEntityError(
            errorType: error.appErrorType));
      },
          (performanceEntity) {

        List<EntityData?>? entityList = performanceEntity.list;
        entityList?.removeWhere((entity)=>entity?.name == 'All Entities');
        EntityData? selectedEntity = (performanceEntity.list?.isNotEmpty ?? false) ? performanceEntity.list?.first : null;

        if(savedEntity != null) {
          selectedEntity = entityList?.firstWhere((entity) => entity?.id == savedEntity.id && entity?.type == savedEntity.type);
          entityList?.removeWhere((entity) => entity?.id == selectedEntity?.id && entity?.type == savedEntity.type);
          entityList?.insert(0, selectedEntity);
        }

        emit(PerformanceEntityLoaded(
            selectedEntity: selectedEntity,
            entityList: entityList?.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformanceEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.performanceEntityList ?? [];

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(PerformanceEntityInitial());
    emit(PerformanceEntityLoaded(
        selectedEntity: selectedEntity,
        entityList: entityList.toSet().toList()
    ));
  }

  Future<void> sortSelectedPerformanceEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.performanceEntityList ?? [];
    EntityData? selectedLastEntity = state.selectedPerformanceEntity;

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(PerformanceEntityInitial());
    emit(PerformanceEntityLoaded(
        selectedEntity: selectedLastEntity,
        entityList: entityList.toSet().toList()
    ));
  }

}