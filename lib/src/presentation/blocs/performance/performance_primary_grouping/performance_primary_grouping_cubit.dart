
import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/usecases/performance/clear_performance.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/performance/performance_primary_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/performance/performance_primary_grouping_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/params/performance/performance_primary_grouping_param.dart';
import '../../../../domain/usecases/performance/get_performance_primary_grouping.dart';
import '../../../../domain/usecases/performance/get_performance_report.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_primary_grouping/get_performance_selected_primary_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_primary_grouping/save_performance_selected_primary_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'performance_primary_grouping_state.dart';

class PerformancePrimaryGroupingCubit extends Cubit<PerformancePrimaryGroupingState> {
  final GetPerformancePrimaryGrouping getPerformanceGrouping;
  final GetPerformanceSelectedPrimaryGrouping getPerformanceSelectedPrimaryGrouping;
  final SavePerformanceSelectedPrimaryGrouping savePerformanceSelectedPrimaryGrouping;
  final ClearPerformance clearPerformance;
  final GetPerformanceReport getPerformanceReport;
  final LoginCheckCubit loginCheckCubit;


  PerformancePrimaryGroupingCubit({
    required this.getPerformanceGrouping,
    required this.getPerformanceSelectedPrimaryGrouping,
    required this.savePerformanceSelectedPrimaryGrouping,
    required this.clearPerformance,
    required this.getPerformanceReport,
    required this.loginCheckCubit,
  })
      : super(PerformancePrimaryGroupingInitial());

  Future<void> loadPerformancePrimaryGrouping({required BuildContext context, bool shouldClearData = false, PrimaryGrouping? favoritePrimaryGrouping, required EntityData? selectedEntity, required String? asOnDate}) async {
    emit(const PerformancePrimaryGroupingLoading());

    if(shouldClearData) {
      await clearPerformance(NoParams());
    }

    final Either<AppError, PerformancePrimaryGroupingEntity>
        eitherPerformancePrimaryGrouping =
        await getPerformanceGrouping(PerformancePrimaryGroupingParam(
          context: context,
          entity: selectedEntity
        ));
    final PrimaryGrouping? savedPrimaryGrouping = favoritePrimaryGrouping ?? await getPerformanceSelectedPrimaryGrouping();

    eitherPerformancePrimaryGrouping.fold(
      (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(PerformancePrimaryGroupingError(
            errorType: error.appErrorType));
      },
      (performanceGrouping) async{

        List<GroupingEntity?>? primaryGroupingList = performanceGrouping.grouping;
        GroupingEntity? selectedPrimaryGrouping = (performanceGrouping.grouping.isNotEmpty ?? false) ? performanceGrouping.grouping.first : null;

        if(savedPrimaryGrouping != null) {
          for(var item in primaryGroupingList) {
            if(item?.id == savedPrimaryGrouping.id) {
              selectedPrimaryGrouping = item;
            }
          }
          primaryGroupingList.removeWhere((primaryGrouping) => primaryGrouping?.id == selectedPrimaryGrouping?.id);
          primaryGroupingList.insert(0, selectedPrimaryGrouping);
        }

        emit(PerformancePrimaryGroupingLoaded(
            selectedPrimaryGrouping: selectedPrimaryGrouping,
            primaryGroupingList: primaryGroupingList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformancePrimaryGrouping({GroupingEntity? selectedGrouping}) async {
    List<GroupingEntity?> primaryGroupingList = state.groupingList ?? [];

    primaryGroupingList.remove(selectedGrouping);
    primaryGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    primaryGroupingList.insert(0, selectedGrouping);

    emit(PerformancePrimaryGroupingInitial());
    emit(PerformancePrimaryGroupingLoaded(
        selectedPrimaryGrouping: selectedGrouping,
        primaryGroupingList: primaryGroupingList.toSet().toList()
    ));
  }

  Future<void> changeSelectedPerformancePrimaryGroupingByName(
      {required BuildContext context, required String selectedGroupingName, required EntityData? selectedEntity, required String? asOnDate}) async {
    print("Fev item: changeSelectedPerformancePrimaryGroupingByName called with grouping name: $selectedGroupingName");

    List<GroupingEntity?> primaryGroupingList = state.groupingList ?? [];

    if (primaryGroupingList.isEmpty) {
      print("Fev item: primaryGroupingList is empty, loading data...");
      await loadPerformancePrimaryGrouping(
        context: context,
          shouldClearData: false,
          selectedEntity: selectedEntity,
          asOnDate: asOnDate
      );
      primaryGroupingList = state.groupingList ?? [];
      print("Fev item: Loaded primaryGroupingList with ${primaryGroupingList.length} items.");
    }

    GroupingEntity? selectedGrouping;

    for (var item in primaryGroupingList) {
      if (item?.name == selectedGroupingName) {
        print("Fev item: ${item?.name} == $selectedGroupingName -> Match found");
        selectedGrouping = item;
        break;
      } else {
        print("Fev item: ${item?.name} != $selectedGroupingName -> Not a match");
      }
    }

    if (selectedGrouping != null) {
      primaryGroupingList.remove(selectedGrouping);
      primaryGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
      primaryGroupingList.insert(0, selectedGrouping);
    } else {
      print("Fev item: No primary grouping found with name: $selectedGroupingName. Skipping reorder.");
    }

    emit(PerformancePrimaryGroupingInitial());
    print("Fev item: Emitted PerformancePrimaryGroupingInitial state");

    emit(PerformancePrimaryGroupingLoaded(
      selectedPrimaryGrouping: selectedGrouping,
      primaryGroupingList: primaryGroupingList.toSet().toList(),
    ));
    print("Fev item: Emitted PerformancePrimaryGroupingLoaded with selected grouping: ${selectedGrouping?.name}");
  }

}
