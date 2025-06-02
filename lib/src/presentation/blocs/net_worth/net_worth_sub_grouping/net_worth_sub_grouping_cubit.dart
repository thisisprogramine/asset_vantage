import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/net_worth/net_worth_sub_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_grouping_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_sub_grouping_enity.dart';
import '../../../../domain/entities/partnership_method/partnership_method.dart';
import '../../../../domain/params/net_worth/net_worth_primary_sub_grouping_params.dart';
import '../../../../domain/usecases/net_worth/get_net_worth_sub_grouping.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_primary_sub_grouping/get_net_worth_selected_sub_groups.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_primary_sub_grouping/save_net_worth_selected_sub_groups.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'net_worth_sub_grouping_state.dart';

class NetWorthPrimarySubGroupingCubit
    extends Cubit<NetWorthPrimarySubGroupingState> {
  final GetNetWorthSubGrouping getNetWorthSubGrouping;
  final GetNetWorthSelectedPrimarySubGrouping
  getNetWorthSelectedPrimarySubGrouping;
  final SaveNetWorthSelectedPrimarySubGrouping
  saveNetWorthSelectedPrimarySubGrouping;
  final LoginCheckCubit loginCheckCubit;


  NetWorthPrimarySubGroupingCubit({
    required this.getNetWorthSubGrouping,
    required this.getNetWorthSelectedPrimarySubGrouping,
    required this.saveNetWorthSelectedPrimarySubGrouping,
    required this.loginCheckCubit,
  }) : super(NetWorthPrimarySubGroupingInitial());

  Future<void> loadNetWorthPrimarySubGrouping({
    required BuildContext? context,
    List<SubGroupingItem?>? favoriteSubGroupingItem,
    required EntityData? selectedEntity,
    required GroupingEntity? selectedGrouping,
    required String? asOnDate,
    PartnershipMethodItemData? selectedPartnershipMethod,
    HoldingMethodItemData? selectedHoldingMethod

  }) async {
    print("call to load sub grp");
    print("DEBUG: selectedHoldingMethod before param creation: $selectedHoldingMethod");
    print("DEBUG: selectedHoldingMethod type: ${selectedHoldingMethod.runtimeType}");

    emit(const NetWorthPrimarySubGroupingLoading());
    emit(const NetWorthPrimarySubGroupingLoading());

    final Either<AppError, NetWorthSubGroupingEntity>
    eitherNetWorthPrimarySubGrouping =
    await getNetWorthSubGrouping(
         NetWorthPrimarySubGroupingParam(
           context: context,
          entity: selectedEntity,
          primaryGrouping: selectedGrouping,
          asOnDate: asOnDate,
           partnershipMethod: selectedPartnershipMethod,
           holdingMethod: selectedHoldingMethod
        ));
    print("DEBUG: param.holdingMethod: ${selectedHoldingMethod}");
    print("DEBUG: param.holdingMethod type: ${selectedHoldingMethod.runtimeType}");
    final List<SubGroupingItem?>? savedSubGroupingItem = favoriteSubGroupingItem ??
        await getNetWorthSelectedPrimarySubGrouping({
          "entityid": selectedEntity?.id,
          "entitytype": selectedEntity?.type,
          "id": selectedGrouping?.id
        });

    eitherNetWorthPrimarySubGrouping.fold((error) {
      print("in subgrp error");
      emit(NetWorthPrimarySubGroupingError(errorType: error.appErrorType));
    }, (primarySubGrouping) async {
      List<SubGroupingItemData?>? primarySubGroupingList =
          primarySubGrouping.subGroupingList;
      List<SubGroupingItemData?>? selectedPrimarySubGroupingList =
          primarySubGrouping.subGroupingList;

      if (savedSubGroupingItem != null && savedSubGroupingItem.isNotEmpty) {
        selectedPrimarySubGroupingList = primarySubGroupingList
            .where((primarySubGroupingItem) => savedSubGroupingItem.any(
                (selectedPrimarySubGroupingItem) =>
            primarySubGroupingItem?.id ==
                selectedPrimarySubGroupingItem?.id))
            .toList();

        primarySubGroupingList.removeWhere((primarySubGroupingItem) =>
            (selectedPrimarySubGroupingList ?? []).any(
                    (selectedPrimarySubGroupingItem) =>
                selectedPrimarySubGroupingItem?.id ==
                    primarySubGroupingItem?.id));

        primarySubGrouping.subGroupingList = selectedPrimarySubGroupingList +
            primarySubGroupingList;
      }

      emit(NetWorthPrimarySubGroupingLoaded(
          selectedSecondarySubGroupingList: selectedPrimarySubGroupingList,
          secondarySubGroupingList:
          primarySubGrouping.subGroupingList.toSet().toList()));
    });
  }

  Future<void> changeSelectedNetWorthPrimarySubGrouping(
      {required List<SubGroupingItemData?> selectedSubGroupingList}) async {
    List<SubGroupingItemData?> primarySubGroupingList =
        state.subGroupingList ?? [];

    primarySubGroupingList.removeWhere((item1) =>
        selectedSubGroupingList.any((item2) => item1?.id == item2?.id));
    primarySubGroupingList
        .sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));

    emit(NetWorthPrimarySubGroupingInitial());
    emit(NetWorthPrimarySubGroupingLoaded(
        selectedSecondarySubGroupingList: selectedSubGroupingList,
        secondarySubGroupingList: [
          ...selectedSubGroupingList.toSet().toList(),
          ...primarySubGroupingList.toSet().toList()
        ]));
  }
}
