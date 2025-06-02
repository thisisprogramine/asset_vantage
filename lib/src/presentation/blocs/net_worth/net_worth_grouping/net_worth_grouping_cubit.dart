
import 'dart:developer';

import 'package:asset_vantage/src/domain/params/net_worth/net_worth_primary_grouping_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/clear_net_worth.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_primary_grouping/get_net_worth_selected_primary_grouping.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/net_worth/net_worth_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_grouping_entity.dart';
import '../../../../domain/usecases/net_worth/get_net_worth_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../authentication/token/token_cubit.dart';

part 'net_worth_grouping_state.dart';

class NetWorthGroupingCubit
    extends Cubit<NetWorthPrimaryGroupingState> {
  final GetNetWorthGrouping
  getNetWorthGrouping;
  final ClearNetWorth clearNetWorth;
  final GetNetWorthSelectedPrimaryGrouping getNetWorthSelectedPrimaryGrouping;
  final LoginCheckCubit loginCheckCubit;

  NetWorthGroupingCubit({
    required this.getNetWorthGrouping,
    required this.clearNetWorth,
    required this.loginCheckCubit,
    required this.getNetWorthSelectedPrimaryGrouping,
  })
      : super(NetWorthPrimaryGroupingInitial());

  Future<void> loadNetWorthPrimaryGrouping({required BuildContext context, bool shouldClearData = false, PrimaryGrouping? favoritePrimaryGrouping, required EntityData? selectedEntity, required String? asOnDate}) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthPrimaryGroupingLoading());

    if(shouldClearData) {
      await clearNetWorth(NoParams());
    }

    final Either<AppError, NetWorthGroupingEntity>
    eitherNetWorthPrimaryGrouping =
    await getNetWorthGrouping(NetWorthPrimaryGroupingParam(
      context: context,
        entity: selectedEntity
    ));
    final PrimaryGrouping? savedPrimaryGrouping = favoritePrimaryGrouping ?? await getNetWorthSelectedPrimaryGrouping();

    eitherNetWorthPrimaryGrouping.fold(
          (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(NetWorthPrimaryGroupingError(
            errorType: error.appErrorType));
      },
          (netWorthGrouping) async{

        List<GroupingEntity?>? primaryGroupingList = netWorthGrouping.grouping;
        GroupingEntity? selectedPrimaryGrouping = netWorthGrouping.grouping.isNotEmpty ? netWorthGrouping.grouping.first : null;

        if(savedPrimaryGrouping != null) {
          for(var item in primaryGroupingList) {
            if(item?.id == savedPrimaryGrouping.id) {
              selectedPrimaryGrouping = item;
            }
          }
          primaryGroupingList.removeWhere((primaryGrouping) => primaryGrouping?.id == selectedPrimaryGrouping?.id);
          primaryGroupingList.insert(0, selectedPrimaryGrouping);
        }

        log("ds${primaryGroupingList}");
        log("dsvsd$selectedPrimaryGrouping");
        log("vdvs$savedPrimaryGrouping");

        emit(NetWorthPrimaryGroupingLoaded(
            selectedPrimaryGrouping: selectedPrimaryGrouping,
            primaryGroupingList: primaryGroupingList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedNetWorthPrimaryGrouping({GroupingEntity? selectedGrouping}) async {
    List<GroupingEntity?> primaryGroupingList = state.groupingList ?? [];

    primaryGroupingList.remove(selectedGrouping);
    primaryGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    primaryGroupingList.insert(0, selectedGrouping);

    emit(NetWorthPrimaryGroupingInitial());
    emit(NetWorthPrimaryGroupingLoaded(
        selectedPrimaryGrouping: selectedGrouping,
        primaryGroupingList: primaryGroupingList.toSet().toList()
    ));
  }
}
