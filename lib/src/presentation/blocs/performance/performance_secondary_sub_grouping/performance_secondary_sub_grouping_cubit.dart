
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/params/performance/performance_secondary_sub_grouping_param.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/performance/performance_secondary_sub_grouping_model.dart' as secondary;
import '../../../../data/models/performance/performance_primary_sub_grouping_model.dart' as primary;
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/partnership_method/partnership_method.dart';
import '../../../../domain/entities/performance/performance_secondary_grouping_entity.dart';
import '../../../../domain/entities/performance/performance_primary_sub_grouping_enity.dart' as primary;
import '../../../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart';
import '../../../../domain/usecases/performance/get_performance_secondary_sub_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_secondary_sub_grouping/get_performance_selected_secondary_sub_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_secondary_sub_grouping/save_performance_selected_secondary_sub_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'performance_secondary_sub_grouping_state.dart';

class PerformanceSecondarySubGroupingCubit extends Cubit<PerformanceSecondarySubGroupingState> {
  final GetPerformanceSecondarySubGrouping getPerformanceSecondarySubGrouping;
  final GetPerformanceSelectedSecondarySubGrouping getPerformanceSelectedSecondarySubGrouping;
  final SavePerformanceSelectedSecondarySubGrouping savePerformanceSelectedSecondarySubGrouping;
  final LoginCheckCubit loginCheckCubit;

  PerformanceSecondarySubGroupingCubit({
    required this.getPerformanceSecondarySubGrouping,
    required this.getPerformanceSelectedSecondarySubGrouping,
    required this.savePerformanceSelectedSecondarySubGrouping,
        required this.loginCheckCubit,
      }): super(PerformanceSecondarySubGroupingInitial());

  Future<void> loadPerformanceSecondarySubGrouping({
    required BuildContext? context,
    List<secondary.SubGroupingItem?>? favoriteSubGroupingItem,
    required List<primary.SubGroupingItemData?>? primarySubGroupingItem,
    required EntityData? selectedEntity,
    required GroupingEntity? selectedGrouping,
    required String? asOnDate,
    PartnershipMethodItemData? selectedPartnershipMethod,
    HoldingMethodItemData? selectedHoldingMethod,
  })
  async {
    emit(PerformanceSecondarySubGroupingInitial());

    final Either<AppError, PerformanceSecondarySubGroupingEntity>
    eitherPerformanceSecondarySubGrouping =
    await getPerformanceSecondarySubGrouping(PerformanceSecondarySubGroupingParam(
      context: context,
      entity: selectedEntity,
      primarySubGroupingItem: primarySubGroupingItem,
      primaryGrouping: selectedGrouping,
      asOnDate: asOnDate,
      partnershipMethod: selectedPartnershipMethod,
      holdingMethod: selectedHoldingMethod

    ));
    final List<secondary.SubGroupingItem?>? savedSubGroupingItem = favoriteSubGroupingItem ?? await getPerformanceSelectedSecondarySubGrouping({"entityid": selectedEntity?.id, "entitytype": selectedEntity?.type, "id": selectedGrouping?.id});


    eitherPerformanceSecondarySubGrouping.fold((error) {

      emit(PerformanceSecondarySubGroupingError(errorType: error.appErrorType));
    }, (secondarySubGrouping) async {

      List<SubGroupingItemData?>? secondarySubGroupingList = secondarySubGrouping.subGroupingList;
      List<SubGroupingItemData?>? selectedSecondarySubGroupingList = secondarySubGrouping.subGroupingList;

      if(savedSubGroupingItem != null && savedSubGroupingItem.isNotEmpty) {
        selectedSecondarySubGroupingList = secondarySubGroupingList.where((secondarySubGroupingItem)
        => savedSubGroupingItem.any((selectedSecondarySubGroupingItem) =>
        secondarySubGroupingItem?.id == selectedSecondarySubGroupingItem?.id)
        ).toList();

        secondarySubGroupingList.removeWhere((secondarySubGroupingItem)
        => (selectedSecondarySubGroupingList ?? []).any((selectedSecondarySubGroupingItem) =>
        selectedSecondarySubGroupingItem?.id == secondarySubGroupingItem?.id));

        secondarySubGrouping.subGroupingList = selectedSecondarySubGroupingList + secondarySubGroupingList;
      }

      emit(PerformanceSecondarySubGroupingLoaded(
          selectedSecondarySubGroupingList: selectedSecondarySubGroupingList.toSet().toList(),
          secondarySubGroupingList: secondarySubGrouping.subGroupingList.toSet().toList()
      ));
    });
  }

  Future<void> changeSelectedPerformanceSecondarySubGrouping({required List<SubGroupingItemData?> selectedSubGroupingList}) async {
    List<SubGroupingItemData?> secondarySubGroupingList = state.subGroupingList ?? [];

    secondarySubGroupingList.removeWhere((item1) => selectedSubGroupingList.any((item2) => item1?.id == item2?.id));
    secondarySubGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));

    emit(PerformanceSecondarySubGroupingInitial());
    emit(PerformanceSecondarySubGroupingLoaded(
        selectedSecondarySubGroupingList: selectedSubGroupingList,
        secondarySubGroupingList: [...selectedSubGroupingList.toSet().toList(), ...secondarySubGroupingList.toSet().toList()]
    ));
  }
  Future<void> selectSecondarySubGroupingByNames({
    required List<String?> subGroupingNames,
  })
  async {
    if (state.subGroupingList == null || state.subGroupingList!.isEmpty) {
      emit(const PerformanceSecondarySubGroupingLoading());
      return;
    }
    List<SubGroupingItemData?> selectedSubGroupingList = state.subGroupingList!
        .where((subGrouping) => subGroupingNames.contains(subGrouping?.name))
        .toList();

    List<SubGroupingItemData?> remainingSubGroupingList = state.subGroupingList!
        .where((subGrouping) => !selectedSubGroupingList.contains(subGrouping))
        .toList();
    emit(PerformanceSecondarySubGroupingLoaded(
      selectedSecondarySubGroupingList: selectedSubGroupingList,
      secondarySubGroupingList: [...selectedSubGroupingList, ...remainingSubGroupingList],
    ));
  }
}
