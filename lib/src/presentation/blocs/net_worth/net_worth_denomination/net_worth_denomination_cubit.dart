import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "dart:developer";

import '../../../../data/models/denomination/denomination_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/denomination/get_denomination.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_denomination/get_net_worth_selected_denomination.dart';
import '../../authentication/token/token_cubit.dart';

part 'net_worth_denomination_state.dart';

class NetWorthDenominationCubit extends Cubit<NetWorthDenominationState> {
  final GetDenomination getDenomination;
  final GetNetWorthSelectedDenomination getNetWorthSelectedDenomination;

  NetWorthDenominationCubit({
    required this.getDenomination,
    required this.getNetWorthSelectedDenomination,
  })
      : super(NetWorthDenominationInitial());

  Future<void> loadNetWorthDenomination({required BuildContext context, DenData? favoriteDenData}) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthDenominationLoading());

    final Either<AppError, DenominationEntity>
        eitherDenomination =
        await getDenomination(context);
    final DenData? savedDenomination = favoriteDenData ?? await getNetWorthSelectedDenomination();

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

        emit(NetWorthDenominationLoaded(
            selectedDenomination: selectedDenomination,
            entityList: denominationList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedNetWorthDenomination({DenominationData? selectedDenomination}) async {
    List<DenominationData?> denominationList = state.netWorthDenominationList ?? [];

    denominationList.remove(selectedDenomination);
    denominationList.sort((a, b) => (a?.id.toString() ?? '').compareTo((b?.id.toString() ?? '')));
    denominationList.insert(0, selectedDenomination);

    emit(NetWorthDenominationInitial());
    emit(NetWorthDenominationLoaded(
        selectedDenomination: selectedDenomination,
        entityList: denominationList.toSet().toList()
    ));
  }

}
