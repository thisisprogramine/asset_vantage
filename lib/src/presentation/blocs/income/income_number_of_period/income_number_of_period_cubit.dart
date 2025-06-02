
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/income/income_filter/selected_number_of_period/get_income_selected_number_of_period.dart';
import '../../../../domain/usecases/income/income_filter/selected_number_of_period/save_income_selected_number_of_period.dart';
import '../../../../domain/usecases/number_of_period/get_number_of_period.dart';
import '../income_chart/income_chart_cubit.dart';

part 'income_number_of_period_state.dart';

class IncomeNumberOfPeriodCubit extends Cubit<IncomeNumberOfPeriodState> {
  final GetNumberOfPeriod getNumberOfPeriod;
  final IncomeChartCubit incomeChartCubit;
  final GetIncomeSelectedNumberOfPeriod getIncomeSelectedNumberOfPeriod;
  final SaveIncomeSelectedNumberOfPeriod saveIncomeSelectedNumberOfPeriod;

  IncomeNumberOfPeriodCubit({
    required this.getNumberOfPeriod,
    required this.incomeChartCubit,
    required this.getIncomeSelectedNumberOfPeriod,
    required this.saveIncomeSelectedNumberOfPeriod,
  })
      : super(IncomeNumberOfPeriodInitial());

  Future<void> loadIncomeNumberOfPeriod({required BuildContext context, NumberOfPeriodItem? favoriteNumberOfPeriod}) async {
    emit(const IncomeNumberOfPeriodLoading());

    final Either<AppError, NumberOfPeriodEntity>
    eitherNumberOfPeriod =
    await getNumberOfPeriod(context);
    final NumberOfPeriodItem? savedNumberOfPeriod = favoriteNumberOfPeriod ?? await getIncomeSelectedNumberOfPeriod();

    eitherNumberOfPeriod.fold(
          (error) {

      },
          (numberOfPeriodEntity) {

            List<NumberOfPeriodItemData?> numberOfPeriodList = numberOfPeriodEntity.periodList ?? [];
            NumberOfPeriodItemData? selectedNumberOfPeriod = (numberOfPeriodEntity.periodList.isNotEmpty) ? numberOfPeriodEntity.periodList.last : null;

            if(savedNumberOfPeriod != null) {

              for(var item in numberOfPeriodList) {
                if(item?.id == savedNumberOfPeriod.id) {
                  selectedNumberOfPeriod = item;
                }
              }

              numberOfPeriodList.removeWhere((period) => period?.id == selectedNumberOfPeriod?.id);
              numberOfPeriodList.insert(0, selectedNumberOfPeriod);
            }

            incomeChartCubit.changeSelectedIndex(selectedIndex: incomeChartCubit.state, selectedNumberOfPeriod: selectedNumberOfPeriod?.value);


            emit(IncomeNumberOfPeriodLoaded(
            selectedNumberOfPeriod: selectedNumberOfPeriod,
            entityList: numberOfPeriodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedIncomeNumberOfPeriod({NumberOfPeriodItemData? selectedNumberOfPeriod}) async {
    List<NumberOfPeriodItemData?> numberOfPeriodList = state.incomeNumberOfPeriodList ?? [];

    numberOfPeriodList.remove(selectedNumberOfPeriod);
    numberOfPeriodList.sort((a, b) => (a?.value ?? 0).compareTo((b?.value ?? 0)));
    numberOfPeriodList.insert(0, selectedNumberOfPeriod);

    incomeChartCubit.changeSelectedIndex(selectedIndex: incomeChartCubit.state, selectedNumberOfPeriod: selectedNumberOfPeriod?.value);

    emit(IncomeNumberOfPeriodInitial());
    emit(IncomeNumberOfPeriodLoaded(
        selectedNumberOfPeriod: selectedNumberOfPeriod,
        entityList: numberOfPeriodList.toSet().toList()
    ));
  }
}
