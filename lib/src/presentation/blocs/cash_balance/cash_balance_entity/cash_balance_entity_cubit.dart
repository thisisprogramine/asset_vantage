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
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_entity/get_cash_balance_selected_entity.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_entity/save_performance_selected_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'cash_balance_entity_state.dart';

class CashBalanceEntityCubit extends Cubit<CashBalanceEntityState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final GetCashBalanceSelectedEntity getCashBalanceSelectedEntity;
  final SaveCashBalanceSelectedEntity saveCashBalanceSelectedEntity;
  final LoginCheckCubit loginCheckCubit;


  CashBalanceEntityCubit({
    required this.getDashboardEntityListData,
    required this.getCashBalanceSelectedEntity,
    required this.saveCashBalanceSelectedEntity,
    required this.loginCheckCubit,
  })
      : super(CashBalanceEntityInitial());

  Future<void> loadCashBalanceEntity({required BuildContext context, bool shouldClearData = false,required String tileName, Entity? favoriteEntity}) async {
    emit(const CashBalanceEntityLoading());

    final Either<AppError, DashboardEntity> eitherDashboardEntityListData = await getDashboardEntityListData(context);
    final Entity? savedEntity = favoriteEntity ?? await getCashBalanceSelectedEntity(tileName);
    
    eitherDashboardEntityListData.fold(
      (error) {

        return emit(CashBalanceEntityError(
            errorType: error.appErrorType));
      },
          (cashBalanceEntity) {

        List<EntityData?>? entityList = cashBalanceEntity.list;
        entityList?.removeWhere((entity)=>entity?.name == 'All Entities');
        EntityData? selectedEntity = (cashBalanceEntity.list?.isNotEmpty ?? false) ? cashBalanceEntity.list?.first : null;
        
        if(savedEntity != null) {
          selectedEntity = entityList?.firstWhere((entity) => entity?.id == savedEntity.id && entity?.type == savedEntity.type);
          entityList?.removeWhere((entity) => entity?.id == selectedEntity?.id && entity?.type == savedEntity.type);
          entityList?.insert(0, selectedEntity);
        }

        emit(CashBalanceEntityLoaded(
            selectedEntity: selectedEntity,
            entityList: entityList?.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedCashBalanceEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.cashBalanceEntityList ?? [];

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(CashBalanceEntityInitial());
    emit(CashBalanceEntityLoaded(
        selectedEntity: selectedEntity,
        entityList: entityList.toSet().toList()
    ));
  }

  Future<void> sortSelectedCashBalanceEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.cashBalanceEntityList ?? [];
    EntityData? selectedLastEntity = state.selectedCashBalanceEntity;

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(CashBalanceEntityInitial());
    emit(CashBalanceEntityLoaded(
        selectedEntity: selectedLastEntity,
        entityList: entityList.toSet().toList()
    ));
  }
}
