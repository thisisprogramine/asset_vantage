import 'package:asset_vantage/src/domain/usecases/performance/clear_performance.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/performance/performance_secondary_grouping_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/params/performance/performance_secondary_grouping_param.dart';
import '../../../../domain/usecases/performance/get_performance_report.dart';
import '../../../../domain/usecases/performance/get_performance_secondary_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_secondary_grouping/get_performance_selected_secondary_grouping.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_secondary_grouping/save_performance_selected_secondary_grouping.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'performance_secondary_grouping_state.dart';

class PerformanceSecondaryGroupingCubit extends Cubit<PerformanceSecondaryGroupingState> {
  final GetPerformanceSecondaryGrouping getPerformanceSecondaryGrouping;
  final GetPerformanceSelectedSecondaryGrouping getPerformanceSelectedSecondaryGrouping;
  final SavePerformanceSelectedSecondaryGrouping savePerformanceSelectedSecondaryGrouping;
  final ClearPerformance clearPerformance;
  final GetPerformanceReport getPerformanceReport;
  final LoginCheckCubit loginCheckCubit;


  PerformanceSecondaryGroupingCubit({
    required this.getPerformanceSecondaryGrouping,
    required this.getPerformanceSelectedSecondaryGrouping,
    required this.savePerformanceSelectedSecondaryGrouping,
    required this.clearPerformance,
    required this.getPerformanceReport,
    required this.loginCheckCubit,
  }) : super(PerformanceSecondaryGroupingInitial());

  Future<void> loadPerformanceSecondaryGrouping({required BuildContext context, bool shouldClearData = false, SecondaryGrouping? favoriteSecondaryGrouping, required EntityData? selectedEntity, required String? asOnDate}) async {
    emit(const PerformanceSecondaryGroupingLoading());

    if(shouldClearData) {
      await clearPerformance(NoParams());
    }

    final Either<AppError, PerformanceSecondaryGroupingEntity>
        eitherPerformanceSecondaryGrouping =
        await getPerformanceSecondaryGrouping(PerformanceSecondaryGroupingParam(
          context: context,
            entity: selectedEntity
        ));
    final SecondaryGrouping? savedSecondaryGrouping = favoriteSecondaryGrouping ?? await getPerformanceSelectedSecondaryGrouping();

    eitherPerformanceSecondaryGrouping.fold(
      (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(PerformanceSecondaryGroupingError(
            errorType: error.appErrorType));
      },
      (performanceGrouping) async{

        List<GroupingEntity?>? secondaryGroupingList = performanceGrouping.grouping;
        GroupingEntity? selectedSecondaryGrouping = (performanceGrouping.grouping.isNotEmpty ?? false) ? performanceGrouping.grouping.first : null;

        if(savedSecondaryGrouping != null) {
          for(var item in secondaryGroupingList) {
            if(item?.id == savedSecondaryGrouping.id) {
              selectedSecondaryGrouping = item;
            }
          }
          secondaryGroupingList.removeWhere((secondaryGrouping) => secondaryGrouping?.id == selectedSecondaryGrouping?.id);
          secondaryGroupingList.insert(0, selectedSecondaryGrouping);
        }

        emit(PerformanceSecondaryGroupingLoaded(
            selectedSecondaryGrouping: selectedSecondaryGrouping,
            secondaryGroupingList: secondaryGroupingList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformanceSecondaryGrouping({GroupingEntity? selectedGrouping}) async {
    List<GroupingEntity?> secondaryGroupingList = state.groupingList ?? [];

    secondaryGroupingList.remove(selectedGrouping);
    secondaryGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
    secondaryGroupingList.insert(0, selectedGrouping);


    emit(PerformanceSecondaryGroupingInitial());
    emit(PerformanceSecondaryGroupingLoaded(
        selectedSecondaryGrouping: selectedGrouping,
        secondaryGroupingList: secondaryGroupingList.toSet().toList()
    ));
  }

  Future<void> changeSelectedPerformanceSecondaryGroupingByName(
      {required BuildContext context, required String selectedGroupingName,required EntityData? selectedEntity, required String? asOnDate}) async {
    print("Fev item: changeSelectedPerformanceSecondaryGroupingByName called with grouping name: $selectedGroupingName");

    List<GroupingEntity?> secondaryGroupingList = state.groupingList ?? [];
    if (secondaryGroupingList.isEmpty) {
      print("Fev item: secondaryGroupingList is empty, loading data...");
      await loadPerformanceSecondaryGrouping(
        context: context,
          shouldClearData: false,
          selectedEntity: selectedEntity,
          asOnDate: asOnDate
      );
      secondaryGroupingList = state.groupingList ?? [];
      print("Fev item: Loaded secondaryGroupingList with ${secondaryGroupingList.length} items.");
    }

    GroupingEntity? selectedGrouping;
    for (var item in secondaryGroupingList) {
      if (item?.name == selectedGroupingName) {
        print("Fev item: ${item?.name} == $selectedGroupingName -> Match found");
        selectedGrouping = item;
        break;
      } else {
        print("Fev item: ${item?.name} != $selectedGroupingName -> Not a match");
      }
    }
    if (selectedGrouping != null) {
      secondaryGroupingList.remove(selectedGrouping);
      secondaryGroupingList.sort((a, b) => (a?.name ?? '').compareTo((b?.name ?? '')));
      secondaryGroupingList.insert(0, selectedGrouping);
    } else {
      print("Fev item: No secondary grouping found with name: $selectedGroupingName. Skipping reorder.");
    }
    emit(PerformanceSecondaryGroupingInitial());
    print("Fev item: Emitted PerformanceSecondaryGroupingInitial state");

    emit(PerformanceSecondaryGroupingLoaded(
      selectedSecondaryGrouping: selectedGrouping,
      secondaryGroupingList: secondaryGroupingList.toSet().toList(),
    ));
    print("Fev item: Emitted PerformanceSecondaryGroupingLoaded with selected grouping: ${selectedGrouping?.name}");
  }

}
