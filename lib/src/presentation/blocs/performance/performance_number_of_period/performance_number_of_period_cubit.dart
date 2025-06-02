import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/number_of_period/get_number_of_period.dart';

part 'performance_number_of_period_state.dart';

class PerformanceNumberOfPeriodCubit extends Cubit<PerformanceNumberOfPeriodState> {
  final GetNumberOfPeriod getNumberOfPeriod;


  PerformanceNumberOfPeriodCubit({
    required this.getNumberOfPeriod
  })
      : super(PerformanceNumberOfPeriodInitial());

  Future<void> loadPerformanceNumberOfPeriod({required BuildContext context}) async {
    emit(const PerformanceNumberOfPeriodLoading());

    final Either<AppError, NumberOfPeriodEntity>
        eitherNumberOfPeriod =
        await getNumberOfPeriod(context);

    eitherNumberOfPeriod.fold(
      (error) {
        
      },
      (numberOfPeriodEntity) {

        emit(PerformanceNumberOfPeriodLoaded(
            selectedNumberOfPeriod: (numberOfPeriodEntity.periodList.isNotEmpty) ? numberOfPeriodEntity.periodList.first : null,
            entityList: numberOfPeriodEntity.periodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformanceNumberOfPeriod({NumberOfPeriodItemData? selectedNumberOfPeriod}) async {
    List<NumberOfPeriodItemData> periodList = state.performanceNumberOfPeriodList ?? [];

    emit(PerformanceNumberOfPeriodInitial());
    emit(PerformanceNumberOfPeriodLoaded(
        selectedNumberOfPeriod: selectedNumberOfPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
