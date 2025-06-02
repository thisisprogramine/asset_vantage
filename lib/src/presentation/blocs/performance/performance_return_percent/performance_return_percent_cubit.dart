import 'package:asset_vantage/src/domain/usecases/return_percentage/get_return_percentage.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_return_percent/get_performance_selected_return_percent.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_return_percent/save_performance_selected_return_percent.dart';

part 'performance_return_percent_state.dart';

class PerformanceReturnPercentCubit extends Cubit<PerformanceReturnPercentState> {
  final GetReturnPercentage getReturnPercentage;
  final GetPerformanceSelectedReturnPercent getPerformanceSelectedReturnPercent;
  final SavePerformanceSelectedReturnPercent savePerformanceSelectedReturnPercent;

  PerformanceReturnPercentCubit({
    required this.getReturnPercentage,
    required this.getPerformanceSelectedReturnPercent,
    required this.savePerformanceSelectedReturnPercent,
  })
      : super(PerformanceReturnPercentInitial());

  Future<void> loadPerformanceReturnPercent({required BuildContext context, List<ReturnPercentItem?>? favoriteReturnPercentItem}) async {
    emit(const PerformanceReturnPercentLoading());

    final Either<AppError, ReturnPercentEntity>
        eitherReturnPercent =
        await getReturnPercentage(context);
    final List<ReturnPercentItem?>? savedReturnPercentage = favoriteReturnPercentItem ?? await getPerformanceSelectedReturnPercent();

    eitherReturnPercent.fold(
      (error) {
        
      },
      (returnPercentageEntity) {

        List<ReturnPercentItemData?>? returnPercentList = returnPercentageEntity.returnPercentList;
        List<ReturnPercentItemData?>? selectedReturnPercentList = (returnPercentageEntity.returnPercentList.isNotEmpty && returnPercentageEntity.returnPercentList.length > 4) ? [...returnPercentageEntity.returnPercentList.getRange(0, 4)] : null;

        if(savedReturnPercentage != null && savedReturnPercentage.isNotEmpty) {
          selectedReturnPercentList = returnPercentList.where((primarySubGroupingItem)
          => savedReturnPercentage.any((selectedReturnPercentItem) =>
          primarySubGroupingItem?.id == selectedReturnPercentItem?.id)
          ).toList();

          returnPercentList.removeWhere((primarySubGroupingItem)
          => (selectedReturnPercentList ?? []).any((selectedReturnPercentItem) =>
          selectedReturnPercentItem?.id == primarySubGroupingItem?.id));

          returnPercentageEntity.returnPercentList = selectedReturnPercentList + returnPercentList;
        }
        emit(PerformanceReturnPercentLoaded(
            selectedReturnPercentList: selectedReturnPercentList?.toSet().toList(),
            returnPercentList: returnPercentageEntity.returnPercentList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformanceReturnPercent({required BuildContext context, required List<ReturnPercentItemData?> selectedReturnPercentList}) async {
    List<ReturnPercentItemData?> returnPercentList = state.performanceReturnPercentList ?? [];

    returnPercentList.removeWhere((item1) => selectedReturnPercentList.any((item2) => item1?.id == item2?.id));
    returnPercentList.sort((a, b) => (a?.key ?? '').compareTo((b?.key ?? '')));

    emit(PerformanceReturnPercentInitial());
    emit(PerformanceReturnPercentLoaded(
        selectedReturnPercentList: selectedReturnPercentList,
        returnPercentList: [...selectedReturnPercentList.toSet().toList(), ...returnPercentList.toSet().toList()]
    ));
  }

  Future<void> selectReturnPercentageByNames({required BuildContext context, required List<String?> returnPercentNames}) async {
    if (state.performanceReturnPercentList == null || state.performanceReturnPercentList!.isEmpty) {
      await loadPerformanceReturnPercent(context: context);
    }

    List<ReturnPercentItemData?> returnPercentList = state.performanceReturnPercentList ?? [];
    List<ReturnPercentItemData?> selectedReturnPercentList = [];
    for (var name in returnPercentNames) {
      for (var item in returnPercentList) {
        if (item?.key == name) {
          selectedReturnPercentList.add(item);
        }
      }
    }
    returnPercentList.removeWhere((item) => selectedReturnPercentList.contains(item));
    returnPercentList.sort((a, b) => (a?.key ?? '').compareTo(b?.key ?? ''));

    emit(PerformanceReturnPercentInitial());
    emit(PerformanceReturnPercentLoaded(
      selectedReturnPercentList: selectedReturnPercentList,
      returnPercentList: [...selectedReturnPercentList, ...returnPercentList.toSet().toList()],
    ));
  }
}
