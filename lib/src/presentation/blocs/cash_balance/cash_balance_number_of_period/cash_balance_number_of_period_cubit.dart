import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_number_of_period/get_cash_balance_selected_entity.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_number_of_period/save_performance_selected_entity.dart';
import '../../../../domain/usecases/number_of_period/get_number_of_period.dart';

part 'cash_balance_number_of_period_state.dart';

class CashBalanceNumberOfPeriodCubit extends Cubit<CashBalanceNumberOfPeriodState> {
  final GetNumberOfPeriod getNumberOfPeriod;
  final GetCashBalanceSelectedNumberOfPeriod getCashBalanceSelectedNumberOfPeriod;
  final SaveCashBalanceSelectedNumberOfPeriod saveCashBalanceSelectedNumberOfPeriod;

  CashBalanceNumberOfPeriodCubit({
    required this.getNumberOfPeriod,
    required this.getCashBalanceSelectedNumberOfPeriod,
    required this.saveCashBalanceSelectedNumberOfPeriod,
  })
      : super(CashBalanceNumberOfPeriodInitial());

  Future<void> loadCashBalanceNumberOfPeriod({required BuildContext context, required String tileName, NumberOfPeriodItemData? favoriteNumberOfPeriodItemData}) async {
    emit(const CashBalanceNumberOfPeriodLoading());

    final Either<AppError, NumberOfPeriodEntity>
        eitherNumberOfPeriod =
        await getNumberOfPeriod(context);
    final NumberOfPeriodItemData? savedNumberOfPeriod = favoriteNumberOfPeriodItemData ?? await getCashBalanceSelectedNumberOfPeriod(tileName);

    eitherNumberOfPeriod.fold(
      (error) {},
      (numberOfPeriodEntity) {
        List<NumberOfPeriodItemData> numberOfPeriodList = numberOfPeriodEntity.periodList;
        NumberOfPeriodItemData? selectedNumberOfPeriod = (numberOfPeriodEntity.periodList.isNotEmpty) ? numberOfPeriodEntity.periodList.last : null;

        if(savedNumberOfPeriod != null) {
          selectedNumberOfPeriod = numberOfPeriodList.firstWhere((numberOfPeriod) => numberOfPeriod.id == savedNumberOfPeriod.id);
          numberOfPeriodList.removeWhere((numberOfPeriod) => numberOfPeriod.id == selectedNumberOfPeriod?.id);
          numberOfPeriodList.insert(0, selectedNumberOfPeriod);
        }

        emit(CashBalanceNumberOfPeriodLoaded(
            selectedNumberOfPeriod: selectedNumberOfPeriod,
            entityList: numberOfPeriodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedCashBalanceNumberOfPeriod({NumberOfPeriodItemData? selectedNumberOfPeriod}) async {
    List<NumberOfPeriodItemData> periodList = state.cashBalanceNumberOfPeriodList ?? [];

    emit(CashBalanceNumberOfPeriodInitial());
    emit(CashBalanceNumberOfPeriodLoaded(
        selectedNumberOfPeriod: selectedNumberOfPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
