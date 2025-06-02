
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/period/period_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_period/get_expense_selected_period.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_period/save_expense_selected_period.dart';
import '../../../../domain/usecases/period/get_period.dart';

part 'expense_period_state.dart';

class ExpensePeriodCubit extends Cubit<ExpensePeriodState> {
  final GetPeriod getPeriod;
  final GetExpenseSelectedPeriod getExpenseSelectedPeriod;
  final SaveExpenseSelectedPeriod saveExpenseSelectedPeriod;

  ExpensePeriodCubit({
    required this.getPeriod,
    required this.getExpenseSelectedPeriod,
    required this.saveExpenseSelectedPeriod,
  })
      : super(ExpensePeriodInitial());

  Future<void> loadExpensePeriod({required BuildContext context, PeriodItem? favoritePeriod}) async {
    emit(const ExpensePeriodLoading());

    final Either<AppError, PeriodEntity>
    eitherPeriod =
    await getPeriod(context);
    final PeriodItem? savedPeriod = favoritePeriod ?? await getExpenseSelectedPeriod();

    eitherPeriod.fold(
          (error) {

      },
          (periodEntity) {

            List<PeriodItemData?> periodList = periodEntity.periodList;
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

        emit(ExpensePeriodLoaded(
            selectedPeriod: selectedPeriod,
            entityList: periodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedExpensePeriod({PeriodItemData? selectedPeriod}) async {
    List<PeriodItemData?> periodList = state.expensePeriodList ?? [];

    periodList.remove(selectedPeriod);
    periodList.sort((a, b) => (a?.gaps ?? 0).compareTo((b?.gaps ?? 0)));
    periodList.insert(0, selectedPeriod);

    emit(ExpensePeriodInitial());
    emit(ExpensePeriodLoaded(
        selectedPeriod: selectedPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
