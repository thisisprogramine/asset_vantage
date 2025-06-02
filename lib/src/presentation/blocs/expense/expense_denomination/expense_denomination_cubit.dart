import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/denomination/get_denomination.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_denomination/get_expense_selected_denomination.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_denomination/save_expense_selected_denomination.dart';

part 'expense_denomination_state.dart';

class ExpenseDenominationCubit extends Cubit<ExpenseDenominationState> {
  final GetDenomination getDenomination;
  final GetExpenseSelectedDenomination getExpenseSelectedDenomination;
  final SaveExpenseSelectedDenomination saveExpenseSelectedDenomination;

  ExpenseDenominationCubit({
    required this.getDenomination,
    required this.getExpenseSelectedDenomination,
    required this.saveExpenseSelectedDenomination,
  })
      : super(ExpenseDenominationInitial());

  Future<void> loadExpenseDenomination({required BuildContext context, DenData? favoriteDenData}) async {
    emit(const ExpenseDenominationLoading());

    final Either<AppError, DenominationEntity>
        eitherDenomination =
        await getDenomination(context);
    final DenData? savedDenomination = favoriteDenData ?? await getExpenseSelectedDenomination();

    eitherDenomination.fold(
      (error) {
        
      },
      (denominationEntity) {

        List<DenominationData?> denominationList = denominationEntity.denominationData ?? [];
        DenominationData? selectedDenomination = (denominationEntity.denominationData?.isNotEmpty ?? false) ? denominationEntity.denominationData?.first : null;

        if(savedDenomination != null) {

          for(var item in denominationList) {
            if(item?.id == savedDenomination.id) {
              selectedDenomination = item;
            }
          }

          denominationList.removeWhere((denomination) => denomination?.id == selectedDenomination?.id);
          denominationList.insert(0, selectedDenomination);
        }

        emit(ExpenseDenominationLoaded(
            selectedDenomination: selectedDenomination,
            denominationList: denominationList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedExpenseDenomination({DenominationData? selectedDenomination}) async {
    List<DenominationData?> denominationList = state.expenseDenominationList ?? [];

    denominationList.remove(selectedDenomination);
    denominationList.sort((a, b) => (a?.id.toString() ?? '').compareTo((b?.id.toString() ?? '')));
    denominationList.insert(0, selectedDenomination);

    emit(ExpenseDenominationInitial());
    emit(ExpenseDenominationLoaded(
        selectedDenomination: selectedDenomination,
        denominationList: denominationList.toSet().toList()
    ));
  }
}
