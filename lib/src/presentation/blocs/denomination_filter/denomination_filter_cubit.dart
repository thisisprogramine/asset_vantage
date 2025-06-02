
import 'dart:developer';

import 'package:asset_vantage/src/domain/entities/denomination/denomination_entity.dart';
import 'package:asset_vantage/src/domain/usecases/denomination/get_denomination.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/params/denomination/get_selected_denomination.dart';
import '../../../domain/params/denomination/set_selected_denomination.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/denomination/get_selected_denomination.dart';
import '../../../domain/usecases/denomination/save_selected_denomination.dart';
part 'denomination_filter_state.dart';

class DenominationFilterCubit extends Cubit<DenominationFilterState> {
  final GetDenomination getDenominationList;
  final GetSelectedDenomination getSelectedDenomination;
  final SaveSelectedDenomination saveSelectedDenomination;

  DenominationFilterCubit({
    required this.getDenominationList,
    required this.getSelectedDenomination,
    required this.saveSelectedDenomination,
  }) : super(const DenominationFilterInitial());

  void loadDenominationEntities({required BuildContext context, required String? tileName,}) async{

    emit(DenominationFilterLoading());
    final selectedDeno = await getSelectedDenominationFunc(tileName: tileName);
    final Either<AppError, DenominationEntity> eiterEntityList = await getDenominationList(context);

    eiterEntityList.fold((error) {
      emit(DenominationFilterError(error.message));
    }, (denominationList) {
      List<DenominationData>? initialList = [...(denominationList.denominationData ?? [])];

      emit(DenominationFilterChanged(
        denominationFilterList: initialList,
        cashBalanceSelectedDenomination: initialList.first,
        expenseSelectedDenomination: initialList.first,
        incomeSelectedDenomination: initialList.first,
        netWorthSelectedDenomination: initialList.first,
      )
      );
    });
  }

  Future<void> selectDenominationEntity({DenominationData? denomination, String? report}) async{

    emit(DenominationFilterInitial(
      denominationFilterList: state.denominationFilterList,
      incomeSelectedDenomination: state.incomeDenomination,
      expenseSelectedDenomination: state.expenseDenomination,
      cashBalanceSelectedDenomination: state.cashBalanceDenomination,
      netWorthSelectedDenomination: state.netWorthDenomination,
    ));
    await saveSelectedDenominationFunc(tileName: report, deno: denomination);
    emit(DenominationFilterChanged(
      denominationFilterList: state.denominationFilterList,
      incomeSelectedDenomination: report == 'Income'?denomination:state.incomeDenomination,
      expenseSelectedDenomination: report == 'Expense'?denomination:state.expenseDenomination,
      cashBalanceSelectedDenomination: report == 'Cash Balance'?denomination:state.cashBalanceDenomination,
      netWorthSelectedDenomination: report == 'Net Worth'?denomination:state.netWorthDenomination,
    )
    );
  }

  Future<DenominationData?> getSelectedDenominationFunc({required String? tileName,}) async {
    final Either<AppError, DenominationData?> selectedDenomination = await getSelectedDenomination(GetDenominationFilterParams(tileName: tileName));

    return selectedDenomination.fold((error) {
      log(error.message);
      return null;
    }, (widget) {
      return widget;
    });
  }

  Future<void> saveSelectedDenominationFunc({required String? tileName,required DenominationData? deno,}) async {
    final Either<AppError, void> saveDeno = await saveSelectedDenomination(SaveDenominationFilterParams(tileName: tileName, filter: deno));

    saveDeno.fold((error) {
      log(error.message);
    }, (widget) {
      log('denomination saved');
    });
  }
}
