import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_denomination/get_cash_balance_selected_denomination.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_denomination/save_performance_selected_denomination.dart';
import '../../../../domain/usecases/denomination/get_denomination.dart';

part 'cash_balance_denomination_state.dart';

class CashBalanceDenominationCubit extends Cubit<CashBalanceDenominationState> {
  final GetDenomination getDenomination;
  final GetCashBalanceSelectedDenomination getCashBalanceSelectedDenomination;
  final SaveCashBalanceSelectedDenomination saveCashBalanceSelectedDenomination;

  CashBalanceDenominationCubit({
    required this.getDenomination,
    required this.getCashBalanceSelectedDenomination,
    required this.saveCashBalanceSelectedDenomination,
  })
      : super(CashBalanceDenominationInitial());

  Future<void> loadCashBalanceDenomination({required BuildContext context, required String tileName, DenData? favoriteDenData}) async {
    emit(const CashBalanceDenominationLoading());

    final Either<AppError, DenominationEntity>
        eitherDenomination =
        await getDenomination(context);
    final DenData? savedDenomination = favoriteDenData ?? await getCashBalanceSelectedDenomination(tileName);

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

        emit(CashBalanceDenominationLoaded(
            selectedDenomination: selectedDenomination,
            entityList: denominationList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedCashBalanceDenomination({DenominationData? selectedDenomination}) async {
    List<DenominationData?> denominationList = state.cashBalanceDenominationList ?? [];

    denominationList.remove(selectedDenomination);
    denominationList.sort((a, b) => (a?.id.toString() ?? '').compareTo((b?.id.toString() ?? '')));
    denominationList.insert(0, selectedDenomination);

    emit(CashBalanceDenominationInitial());
    emit(CashBalanceDenominationLoaded(
        selectedDenomination: selectedDenomination,
        entityList: denominationList.toSet().toList()
    ));
  }
}
