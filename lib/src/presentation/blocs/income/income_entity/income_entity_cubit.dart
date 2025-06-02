
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/dashboard/get_dashboard_entity_list.dart';
import '../../../../domain/usecases/income/income_filter/selected_entity/get_income_selected_entity.dart';
import '../../../../domain/usecases/income/income_filter/selected_entity/save_income_selected_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'income_entity_state.dart';

class IncomeEntityCubit extends Cubit<IncomeEntityState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final GetIncomeSelectedEntity getIncomeSelectedEntity;
  final SaveIncomeSelectedEntity saveIncomeSelectedEntity;
  final LoginCheckCubit loginCheckCubit;


  IncomeEntityCubit({
    required this.getDashboardEntityListData,
    required this.getIncomeSelectedEntity,
    required this.saveIncomeSelectedEntity,
    required this.loginCheckCubit,
  })
      : super(IncomeEntityInitial());

  Future<void> loadIncomeEntity({required BuildContext context, bool shouldClearData = false, Entity? favoriteEntity}) async {
    emit(const IncomeEntityLoading());

    final Either<AppError, DashboardEntity> eitherDashboardEntityListData = await getDashboardEntityListData(context);
    final Entity? savedEntity = favoriteEntity ?? await getIncomeSelectedEntity();

    eitherDashboardEntityListData.fold(
      (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(IncomeEntityError(
            errorType: error.appErrorType));
      },
          (incomeEntity) {

        List<EntityData?> entityList = incomeEntity.list ?? [];
        entityList?.removeWhere((entity)=>entity?.name == 'All Entities');
        EntityData? selectedEntity = (incomeEntity.list?.isNotEmpty ?? false) ? incomeEntity.list?.first : null;
        
        if(savedEntity != null) {

          for(var item in entityList) {
            if(item?.id == savedEntity.id && item?.type == savedEntity.type) {
              selectedEntity = item;
            }
          }

          entityList.removeWhere((entity) => entity?.id == selectedEntity?.id && entity?.type == savedEntity.type);
          entityList.insert(0, selectedEntity);
        }

        emit(IncomeEntityLoaded(
            selectedEntity: selectedEntity,
            entityList: entityList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedIncomeEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.incomeEntityList ?? [];

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(IncomeEntityInitial());
    emit(IncomeEntityLoaded(
        selectedEntity: selectedEntity,
        entityList: entityList.toSet().toList()
    ));
  }

  Future<void> sortSelectedIncomeEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.incomeEntityList ?? [];
    EntityData? selectedLastEntity = state.selectedIncomeEntity;

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(IncomeEntityInitial());
    emit(IncomeEntityLoaded(
        selectedEntity: selectedLastEntity,
        entityList: entityList.toSet().toList()
    ));
  }
}