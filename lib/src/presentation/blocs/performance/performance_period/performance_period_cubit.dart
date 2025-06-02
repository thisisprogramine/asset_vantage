import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/period/get_period.dart';

part 'performance_period_state.dart';

class PerformancePeriodCubit extends Cubit<PerformancePeriodState> {
  final GetPeriod getPeriod;


  PerformancePeriodCubit({
    required this.getPeriod
  })
      : super(PerformancePeriodInitial());

  Future<void> loadPerformancePeriod({required BuildContext context}) async {
    emit(const PerformancePeriodLoading());

    final Either<AppError, PeriodEntity>
        eitherPeriod =
        await getPeriod(context);

    eitherPeriod.fold(
      (error) {
        
      },
      (periodEntity) {

        emit(PerformancePeriodLoaded(
            selectedPeriod: (periodEntity.periodList.isNotEmpty) ? periodEntity.periodList.first : null,
            entityList: periodEntity.periodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformancePeriod({PeriodItemData? selectedPeriod}) async {
    List<PeriodItemData> periodList = state.performancePeriodList ?? [];

    emit(PerformancePeriodInitial());
    emit(PerformancePeriodLoaded(
        selectedPeriod: selectedPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
