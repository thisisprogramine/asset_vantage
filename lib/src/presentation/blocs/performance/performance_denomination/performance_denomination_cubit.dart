import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/denomination/get_denomination.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_denomination/get_performance_selected_denomination.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_denomination/save_performance_selected_denomination.dart';

part 'performance_denomination_state.dart';

class PerformanceDenominationCubit extends Cubit<PerformanceDenominationState> {
  final GetDenomination getDenomination;
  final GetPerformanceSelectedDenomination getPerformanceSelectedDenomination;
  final SavePerformanceSelectedDenomination savePerformanceSelectedDenomination;

  PerformanceDenominationCubit({
    required this.getDenomination,
    required this.getPerformanceSelectedDenomination,
    required this.savePerformanceSelectedDenomination,
  })
      : super(PerformanceDenominationInitial());

  Future<void> loadPerformanceDenomination({required BuildContext context, DenData? favoriteDenData}) async {
    emit(const PerformanceDenominationLoading());

    final Either<AppError, DenominationEntity>
        eitherDenomination =
        await getDenomination(context);
    final DenData? savedDenomination = favoriteDenData ?? await getPerformanceSelectedDenomination();

    eitherDenomination.fold(
      (error) {
        
      },
      (denominationEntity) {

        List<DenominationData?> denominationList = denominationEntity.denominationData ?? [];
        DenominationData? selectedDenomination = (denominationEntity.denominationData?.isNotEmpty ?? false) ? denominationEntity.denominationData?.first : null;

        if(savedDenomination != null) {
          selectedDenomination = denominationList.firstWhere((denomination) => denomination?.id == savedDenomination.id);
          denominationList.removeWhere((denomination) => denomination?.id == selectedDenomination?.id);
          denominationList.insert(0, selectedDenomination);
        }


        emit(PerformanceDenominationLoaded(
            selectedDenomination: selectedDenomination,
            entityList: denominationList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformanceDenomination({DenominationData? selectedDenomination}) async {
    List<DenominationData?> denominationList = state.performanceDenominationList ?? [];

    denominationList.remove(selectedDenomination);
    denominationList.sort((a, b) => (a?.id.toString() ?? '').compareTo((b?.id.toString() ?? '')));
    denominationList.insert(0, selectedDenomination);

    emit(PerformanceDenominationInitial());
    emit(PerformanceDenominationLoaded(
        selectedDenomination: selectedDenomination,
        entityList: denominationList.toSet().toList()
    ));
  }

  Future<void> changeSelectedPerformanceDenominationByTitle({
    required BuildContext context,
    required String denominationTitle,
  })
  async {
    List<DenominationData?> denominationList = state.performanceDenominationList ?? [];

    if (denominationList.isEmpty) {
      await loadPerformanceDenomination(context: context);
      denominationList = state.performanceDenominationList ?? [];
    }

    DenominationData? selectedDenomination;
    for (final denomination in denominationList) {
      if (denomination?.title == denominationTitle) {
        selectedDenomination = denomination;
        break;
      }
    }

    if (selectedDenomination != null) {
      denominationList.remove(selectedDenomination);
      denominationList.sort((a, b) => (a?.title ?? '').compareTo((b?.title ?? '')));
      denominationList.insert(0, selectedDenomination);

      emit(PerformanceDenominationInitial());
      emit(PerformanceDenominationLoaded(
        selectedDenomination: selectedDenomination,
        entityList: denominationList.toSet().toList(),
      ));
    } else {
      print("Denomination with title '$denominationTitle' not found in the list.");
    }
  }

}
