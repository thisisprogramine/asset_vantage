import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_period/get_net_worth_selected_period.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/period/period_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/period/get_period.dart';
import '../../authentication/token/token_cubit.dart';

part 'net_worth_period_state.dart';

class NetWorthPeriodCubit extends Cubit<NetWorthPeriodState> {
  final GetPeriod getPeriod;
  final GetNetWorthSelectedPeriod getNetWorthSelectedPeriod;

  NetWorthPeriodCubit({
    required this.getPeriod,
    required this.getNetWorthSelectedPeriod,
  })
      : super(NetWorthPeriodInitial());

  Future<void> loadNetWorthPeriod({required BuildContext context, required String tileName, PeriodItem? favoritePeriod}) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthPeriodLoading());

    final Either<AppError, PeriodEntity>
    eitherPeriod =
    await getPeriod(context);
    final PeriodItemData? savedPeriod = favoritePeriod ?? await getNetWorthSelectedPeriod(tileName);

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

            emit(NetWorthPeriodLoaded(
                selectedPeriod: selectedPeriod,
                entityList: periodList.toSet().toList()
            ));
      },
    );
  }

  Future<void> changeSelectedNetWorthPeriod({PeriodItemData? selectedPeriod}) async {
    List<PeriodItemData> periodList = state.netWorthPeriodList ?? [];

    emit(NetWorthPeriodInitial());
    emit(NetWorthPeriodLoaded(
        selectedPeriod: selectedPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
