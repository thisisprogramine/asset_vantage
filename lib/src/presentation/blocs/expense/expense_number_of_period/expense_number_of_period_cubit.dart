
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_number_of_period/get_expense_selected_number_of_period.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_number_of_period/save_expense_selected_number_of_period.dart';
import '../../../../domain/usecases/number_of_period/get_number_of_period.dart';
import '../expense_chart/expense_chart_cubit.dart';

part 'expense_number_of_period_state.dart';

class ExpenseNumberOfPeriodCubit extends Cubit<ExpenseNumberOfPeriodState> {
  final GetNumberOfPeriod getNumberOfPeriod;
  final ExpenseChartCubit expenseChartCubit;
  final GetExpenseSelectedNumberOfPeriod getExpenseSelectedNumberOfPeriod;
  final SaveExpenseSelectedNumberOfPeriod saveExpenseSelectedNumberOfPeriod;

  ExpenseNumberOfPeriodCubit({
    required this.getNumberOfPeriod,
    required this.expenseChartCubit,
    required this.getExpenseSelectedNumberOfPeriod,
    required this.saveExpenseSelectedNumberOfPeriod,
  })
      : super(ExpenseNumberOfPeriodInitial());

  Future<void> loadExpenseNumberOfPeriod({required BuildContext context, NumberOfPeriodItem? favoriteNumberOfPeriod}) async {
    emit(const ExpenseNumberOfPeriodLoading());

    final Either<AppError, NumberOfPeriodEntity>
    eitherNumberOfPeriod =
    await getNumberOfPeriod(context);
    final NumberOfPeriodItem? savedNumberOfPeriod = favoriteNumberOfPeriod ?? await getExpenseSelectedNumberOfPeriod();

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

            expenseChartCubit.changeSelectedIndex(selectedIndex: expenseChartCubit.state, selectedNumberOfPeriod: selectedNumberOfPeriod?.value);


            emit(ExpenseNumberOfPeriodLoaded(
            selectedNumberOfPeriod: selectedNumberOfPeriod,
            entityList: numberOfPeriodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedExpenseNumberOfPeriod({NumberOfPeriodItemData? selectedNumberOfPeriod}) async {
    List<NumberOfPeriodItemData?> numberOfPeriodList = state.expenseNumberOfPeriodList ?? [];

    numberOfPeriodList.remove(selectedNumberOfPeriod);
    numberOfPeriodList.sort((a, b) => (a?.value ?? 0).compareTo((b?.value ?? 0)));
    numberOfPeriodList.insert(0, selectedNumberOfPeriod);

    expenseChartCubit.changeSelectedIndex(selectedIndex: expenseChartCubit.state, selectedNumberOfPeriod: selectedNumberOfPeriod?.value);

    emit(ExpenseNumberOfPeriodInitial());
    emit(ExpenseNumberOfPeriodLoaded(
        selectedNumberOfPeriod: selectedNumberOfPeriod,
        entityList: numberOfPeriodList.toSet().toList()
    ));
  }
}
