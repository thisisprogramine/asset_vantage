
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_period/get_income_selected_period.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/period/period_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/income/income_filter/selected_period/save_income_selected_period.dart';
import '../../../../domain/usecases/period/get_period.dart';

part 'income_period_state.dart';

class IncomePeriodCubit extends Cubit<IncomePeriodState> {
  final GetPeriod getPeriod;
  final GetIncomeSelectedPeriod getIncomeSelectedPeriod;
  final SaveIncomeSelectedPeriod saveIncomeSelectedPeriod;

  IncomePeriodCubit({
    required this.getPeriod,
    required this.getIncomeSelectedPeriod,
    required this.saveIncomeSelectedPeriod,
  })
      : super(IncomePeriodInitial());

  Future<void> loadIncomePeriod({required BuildContext context, PeriodItem? favoritePeriod}) async {
    emit(const IncomePeriodLoading());

    final Either<AppError, PeriodEntity>
    eitherPeriod =
    await getPeriod(context);
    final PeriodItem? savedPeriod = favoritePeriod ?? await getIncomeSelectedPeriod();

    eitherPeriod.fold(
          (error) {

      },
          (periodEntity) {

            List<PeriodItemData?> periodList = periodEntity.periodList ?? [];
            PeriodItemData? selectedPeriod = (periodEntity.periodList.isNotEmpty) ? periodEntity.periodList.first : null;

            if(savedPeriod != null) {

              for(var item in periodList) {
                if(item?.id == savedPeriod.id) {
                  selectedPeriod = item;
                }
              }

              periodList.removeWhere((period) => period?.id == selectedPeriod?.id);
              periodList.insert(0, selectedPeriod);
            }

        emit(IncomePeriodLoaded(
            selectedPeriod: selectedPeriod,
            entityList: periodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedIncomePeriod({PeriodItemData? selectedPeriod}) async {
    List<PeriodItemData?> periodList = state.incomePeriodList ?? [];

    periodList.remove(selectedPeriod);
    periodList.sort((a, b) => (a?.gaps ?? 0).compareTo((b?.gaps ?? 0)));
    periodList.insert(0, selectedPeriod);

    emit(IncomePeriodInitial());
    emit(IncomePeriodLoaded(
        selectedPeriod: selectedPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
