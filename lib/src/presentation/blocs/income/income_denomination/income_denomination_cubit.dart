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
import '../../../../domain/usecases/income/income_filter/selected_denomination/get_income_selected_denomination.dart';
import '../../../../domain/usecases/income/income_filter/selected_denomination/save_income_selected_denomination.dart';

part 'income_denomination_state.dart';

class IncomeDenominationCubit extends Cubit<IncomeDenominationState> {
  final GetDenomination getDenomination;
  final GetIncomeSelectedDenomination getIncomeSelectedDenomination;
  final SaveIncomeSelectedDenomination saveIncomeSelectedDenomination;

  IncomeDenominationCubit({
    required this.getDenomination,
    required this.getIncomeSelectedDenomination,
    required this.saveIncomeSelectedDenomination,
  })
      : super(IncomeDenominationInitial());

  Future<void> loadIncomeDenomination({required BuildContext context, DenData? favoriteDenData}) async {
    emit(const IncomeDenominationLoading());

    final Either<AppError, DenominationEntity>
        eitherDenomination =
        await getDenomination(context);
    final DenData? savedDenomination = favoriteDenData ?? await getIncomeSelectedDenomination();

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

        emit(IncomeDenominationLoaded(
            selectedDenomination: selectedDenomination,
            denominationList: denominationList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedIncomeDenomination({DenominationData? selectedDenomination}) async {
    List<DenominationData?> denominationList = state.incomeDenominationList ?? [];

    denominationList.remove(selectedDenomination);
    denominationList.sort((a, b) => (a?.id.toString() ?? '').compareTo((b?.id.toString() ?? '')));
    denominationList.insert(0, selectedDenomination);

    emit(IncomeDenominationInitial());
    emit(IncomeDenominationLoaded(
        selectedDenomination: selectedDenomination,
        denominationList: denominationList.toSet().toList()
    ));
  }
}
