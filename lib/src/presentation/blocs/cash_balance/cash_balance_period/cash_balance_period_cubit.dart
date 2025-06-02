import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_period/get_cash_balance_selected_entity.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_period/save_performance_selected_entity.dart';
import '../../../../domain/usecases/period/get_period.dart';

part 'cash_balance_period_state.dart';

class CashBalancePeriodCubit extends Cubit<CashBalancePeriodState> {
  final GetPeriod getPeriod;
  final GetCashBalanceSelectedPeriod getCashBalanceSelectedPeriod;
  final SaveCashBalanceSelectedPeriod saveCashBalanceSelectedPeriod;

  CashBalancePeriodCubit({
    required this.getPeriod,
    required this.getCashBalanceSelectedPeriod,
    required this.saveCashBalanceSelectedPeriod,
  })
      : super(CashBalancePeriodInitial());

  Future<void> loadCashBalancePeriod({required BuildContext context, required String tileName, PeriodItemData? favoritePeriod}) async {
    emit(const CashBalancePeriodLoading());

    final Either<AppError, PeriodEntity>
        eitherPeriod =
        await getPeriod(context);
    final PeriodItemData? savedPeriod = favoritePeriod ?? await getCashBalanceSelectedPeriod(tileName);

    eitherPeriod.fold(
      (error) {
        
      },
      (periodEntity) {
        List<PeriodItemData> periodList = periodEntity.periodList;
        PeriodItemData? selectedPeriod = (periodEntity.periodList.isNotEmpty) ? periodEntity.periodList.first : null;

        if(savedPeriod != null) {
          selectedPeriod = periodList.firstWhere((numberOfPeriod) => numberOfPeriod.id == savedPeriod.id);
          periodList.removeWhere((numberOfPeriod) => numberOfPeriod.id == selectedPeriod?.id);
          periodList.insert(0, selectedPeriod);
        }

        emit(CashBalancePeriodLoaded(
            selectedPeriod: selectedPeriod,
            entityList: periodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedCashBalancePeriod({PeriodItemData? selectedPeriod}) async {
    List<PeriodItemData> periodList = state.cashBalancePeriodList ?? [];

    emit(CashBalancePeriodInitial());
    emit(CashBalancePeriodLoaded(
        selectedPeriod: selectedPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
