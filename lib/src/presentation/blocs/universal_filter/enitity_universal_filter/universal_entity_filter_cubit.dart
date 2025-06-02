import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/domain/usecases/dashboard/get_dashboard_entity_list.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'universal_entity_filter_state.dart';

class UniversalEntityFilterCubit extends Cubit<UniversalEntityFilterState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final LoginCheckCubit loginCheckCubit;


  UniversalEntityFilterCubit({
    required this.getDashboardEntityListData,
    required this.loginCheckCubit,
  })
      : super(UniversalEntityInitial());

  Future<void> loadUniversalEntity({required BuildContext context}) async {
    emit(const UniversalEntityLoading());

    final Either<AppError, DashboardEntity> eitherDashboardEntityListData = await getDashboardEntityListData(context);

    eitherDashboardEntityListData.fold(
      (error) {
        return emit(UniversalEntityError(
            errorType: error.appErrorType));
      },
          (universalEntity) {

        List<EntityData?>? entityList = universalEntity.list;
        entityList?.removeWhere((entity)=>entity?.name == 'All Entities');
        EntityData? selectedEntity = (universalEntity.list?.isNotEmpty ?? false) ? universalEntity.list?.first : null;


        emit(UniversalEntityLoaded(
            selectedEntity: selectedEntity,
            entityList: entityList?.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedUniversalEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.universalEntityList ?? [];

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(UniversalEntityInitial());
    emit(UniversalEntityLoaded(
        selectedEntity: selectedEntity,
        entityList: entityList.toSet().toList()
    ));
  }

  Future<void> sortSelectedUniversalEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.universalEntityList ?? [];
    EntityData? selectedLastEntity = state.selectedUniversalEntity;

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(UniversalEntityInitial());
    emit(UniversalEntityLoaded(
        selectedEntity: selectedLastEntity,
        entityList: entityList.toSet().toList()
    ));
  }

}