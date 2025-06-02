import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_primary_sub_grouping_param.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/performance/performance_primary_sub_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/performance/performance_primary_grouping_entity.dart';
import '../../../../domain/entities/performance/performance_primary_sub_grouping_enity.dart';
import '../../../../domain/usecases/performance/get_performance_primary_sub_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_primary_sub_grouping/get_performance_selected_primary_sub_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_primary_sub_grouping/save_performance_selected_primary_sub_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'performance_primary_sub_grouping_state.dart';

class PerformancePrimarySubGroupingCubit
    extends Cubit<PerformancePrimarySubGroupingState> {
  final GetPerformancePrimarySubGrouping getPerformancePrimarySubGrouping;
  final GetPerformanceSelectedPrimarySubGrouping
      getPerformanceSelectedPrimarySubGrouping;
  final SavePerformanceSelectedPrimarySubGrouping
      savePerformanceSelectedPrimarySubGrouping;
  final LoginCheckCubit loginCheckCubit;

  PerformancePrimarySubGroupingCubit({
    required this.getPerformancePrimarySubGrouping,
    required this.getPerformanceSelectedPrimarySubGrouping,
    required this.savePerformanceSelectedPrimarySubGrouping,
    required this.loginCheckCubit,
  }) : super(PerformancePrimarySubGroupingInitial());

  Future<void> loadPerformancePrimarySubGrouping({
    required BuildContext? context,
    List<SubGroupingItem?>? favoriteSubGroupingItem,
    required EntityData? selectedEntity,
    required GroupingEntity? selectedGrouping,
    required String? asOnDate,
    PartnershipMethodItemData? selectedPartnershipMethod,
    HoldingMethodItemData? selectedHoldingMethod
  }) async {

    emit(const PerformancePrimarySubGroupingLoading());

    final Either<AppError, PerformancePrimarySubGroupingEntity>
        eitherPerformancePrimarySubGrouping =
        await getPerformancePrimarySubGrouping(
            PerformancePrimarySubGroupingParam(
              context: context,
      entity: selectedEntity,
      primaryGrouping: selectedGrouping,
      asOnDate: asOnDate,
      partnershipMethod: selectedPartnershipMethod,
      holdingMethod: selectedHoldingMethod
    ));
    final List<SubGroupingItem?>? savedSubGroupingItem = favoriteSubGroupingItem ??
        await getPerformanceSelectedPrimarySubGrouping({
      "entityid": selectedEntity?.id,
      "entitytype": selectedEntity?.type,
      "id": selectedGrouping?.id
    });

    eitherPerformancePrimarySubGrouping.fold((error) {

      emit(PerformancePrimarySubGroupingError(errorType: error.appErrorType));
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

      emit(PerformancePrimarySubGroupingLoaded(
          selectedSecondarySubGroupingList: selectedPrimarySubGroupingList,
          secondarySubGroupingList:
              primarySubGrouping.subGroupingList.toSet().toList()));
    });
  }

  Future<void> changeSelectedPerformancePrimarySubGrouping(
      {required List<SubGroupingItemData?> selectedSubGroupingList}) async {
    List<SubGroupingItemData?> primarySubGroupingList =
        state.subGroupingList ?? [];

    primarySubGroupingList.removeWhere((item1) =>
        selectedSubGroupingList.any((item2) => item1?.id == item2?.id));
    primarySubGroupingList
        .sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));

    emit(PerformancePrimarySubGroupingInitial());
    emit(PerformancePrimarySubGroupingLoaded(
        selectedSecondarySubGroupingList: selectedSubGroupingList,
        secondarySubGroupingList: [
          ...selectedSubGroupingList.toSet().toList(),
          ...primarySubGroupingList.toSet().toList()
        ]));
  }

  Future<void> changeSelectedPerformancePrimarySubGroupingByNameList({
    required BuildContext context,
    required List<SubGroupingItemData?> selectedSubGroupingNames,
    EntityData? selectedEntity,
    GroupingEntity? selectedGrouping,
    String? asOnDate,
  })
  async {
    print(
        "Fev item: Starting changeSelectedPerformancePrimarySubGroupingByNameList with names: $selectedSubGroupingNames");
    if (state.subGroupingList == null || state.subGroupingList!.isEmpty) {
      print("Fev item: SubGrouping list is empty, loading data...");
      await loadPerformancePrimarySubGrouping(
        context: context,
        selectedEntity: selectedEntity,
        selectedGrouping: selectedGrouping,
        asOnDate: asOnDate,
      );
    }

    List<SubGroupingItemData?> primarySubGroupingList =
        state.subGroupingList ?? [];
    print(
        "Fev item: Loaded subGroupingList with ${primarySubGroupingList.length} items.");

    List<SubGroupingItemData?> selectedSubGroupingList = [];
    for (var name in selectedSubGroupingNames) {
      for (var item in primarySubGroupingList) {
        if (item?.name == name) {
          selectedSubGroupingList.add(item);
          print("Fev item: Match found for name $name -> ${item?.name}");
        } else {
          print("Fev item: No match for name $name with item ${item?.name}");
        }
      }
    }

    primarySubGroupingList
        .removeWhere((item) => selectedSubGroupingList.contains(item));
    primarySubGroupingList
        .sort((a, b) => (a?.name ?? '').compareTo(b?.name ?? ''));

    emit(PerformancePrimarySubGroupingInitial());
    emit(PerformancePrimarySubGroupingLoaded(
      selectedSecondarySubGroupingList: selectedSubGroupingList,
      secondarySubGroupingList: [
        ...selectedSubGroupingList,
        ...primarySubGroupingList.toSet().toList()
      ],
    ));

    print(
        "Fev item: Emitted new state with selected sub-grouping list containing ${selectedSubGroupingList.length} items.");
  }
}
