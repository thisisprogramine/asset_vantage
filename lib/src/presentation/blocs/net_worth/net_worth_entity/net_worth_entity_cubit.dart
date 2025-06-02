import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/domain/usecases/dashboard/get_dashboard_entity_list.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/token/token_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_entity/get_net_worth_selected_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'net_worth_entity_state.dart';

class NetWorthEntityCubit extends Cubit<NetWorthEntityState> {
  final GetDashboardEntityListData getDashboardEntityListData;
  final GetNetWorthSelectedEntity getNetWorthSelectedEntity;
  final LoginCheckCubit loginCheckCubit;


  NetWorthEntityCubit({
    required this.getDashboardEntityListData,
    required this.getNetWorthSelectedEntity,
    required this.loginCheckCubit,
  })
      : super(NetWorthEntityInitial());

  Future<void> loadNetWorthEntity({required BuildContext context, bool shouldClearData = false, Entity? favoriteEntity}) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthEntityLoading());

    final Either<AppError, DashboardEntity> eitherDashboardEntityListData = await getDashboardEntityListData(context);
    final Entity? savedEntity = favoriteEntity ?? await getNetWorthSelectedEntity();
    
    eitherDashboardEntityListData.fold(
      (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(NetWorthEntityError(
            errorType: error.appErrorType));
      },
          (netWorthEntity) {

        List<EntityData?>? entityList = netWorthEntity.list;
        entityList?.removeWhere((entity)=>entity?.name == 'All Entities');
        EntityData? selectedEntity = (netWorthEntity.list?.isNotEmpty ?? false) ? netWorthEntity.list?.first : null;

        if(savedEntity != null) {
          selectedEntity = entityList?.firstWhere((entity) => entity?.id == savedEntity.id && entity?.type == savedEntity.type);
          entityList?.removeWhere((entity) => entity?.id == selectedEntity?.id && entity?.type == savedEntity.type);
          entityList?.insert(0, selectedEntity);
        }

        emit(NetWorthEntityLoaded(
            selectedEntity: selectedEntity,
            entityList: entityList?.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedNetWorthEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.netWorthEntityList ?? [];

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(NetWorthEntityInitial());
    emit(NetWorthEntityLoaded(
        selectedEntity: selectedEntity,
        entityList: entityList.toSet().toList()
    ));
  }

  Future<void> sortSelectedNetWorthEntity({EntityData? selectedEntity}) async {
    List<EntityData?> entityList = state.netWorthEntityList ?? [];
    EntityData? selectedLastEntity = state.selectedNetWorthEntity;

    entityList.remove(selectedEntity);
    entityList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    entityList.insert(0, selectedEntity);

    emit(NetWorthEntityInitial());
    emit(NetWorthEntityLoaded(
        selectedEntity: selectedLastEntity,
        entityList: entityList.toSet().toList()
    ));
  }
}