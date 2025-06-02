
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/dashboard_entity_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/dashboard/get_dashboard_entity_list.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_entity/get_expense_selected_entity.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_entity/save_expense_selected_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'expense_entity_state.dart';

class ExpenseEntityCubit extends Cubit<ExpenseEntityState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final GetExpenseSelectedEntity getExpenseSelectedEntity;
  final SaveExpenseSelectedEntity saveExpenseSelectedEntity;
  final LoginCheckCubit loginCheckCubit;


  ExpenseEntityCubit({
    required this.getDashboardEntityListData,
    required this.getExpenseSelectedEntity,
    required this.saveExpenseSelectedEntity,
    required this.loginCheckCubit,
  })
      : super(ExpenseEntityInitial());

  Future<void> loadExpenseEntity({required BuildContext context, bool shouldClearData = false, Entity? favoriteEntity}) async {
    emit(const ExpenseEntityLoading());

    final Either<AppError, DashboardEntity> eitherDashboardEntityListData = await getDashboardEntityListData(context);
    final Entity? savedEntity = favoriteEntity ?? await getExpenseSelectedEntity();

    eitherDashboardEntityListData.fold(
      (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(ExpenseEntityError(
            errorType: error.appErrorType));
      },
          (expenseEntity) {

        List<EntityData?> entityList = expenseEntity.list ?? [];
        entityList?.removeWhere((entity)=>entity?.name == 'All Entities');
        EntityData? selectedEntity = (expenseEntity.list?.isNotEmpty ?? false) ? expenseEntity.list?.first : null;
        
        if(savedEntity != null) {

          for(var item in entityList) {
            if(item?.id == savedEntity.id && item?.type == savedEntity.type) {
              selectedEntity = item;
            }
          }

          entityList.removeWhere((entity) => entity?.id == selectedEntity?.id && entity?.type == savedEntity.type);
          entityList.insert(0, selectedEntity);
        }

        emit(ExpenseEntityLoaded(
            selectedEntity: selectedEntity,
            entityList: entityList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedExpenseEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.expenseEntityList ?? [];

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(ExpenseEntityInitial());
    emit(ExpenseEntityLoaded(
        selectedEntity: selectedEntity,
        entityList: entityList.toSet().toList()
    ));
  }

  Future<void> sortSelectedExpenseEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.expenseEntityList ?? [];
    EntityData? selectedLastEntity = state.selectedExpenseEntity;

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(ExpenseEntityInitial());
    emit(ExpenseEntityLoaded(
        selectedEntity: selectedLastEntity,
        entityList: entityList.toSet().toList()
    ));
  }
}
