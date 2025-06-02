import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_number_of_period/get_net_worth_selected_number_of_period.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/number_of_period/number_of_period_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/number_of_period/number_of_period.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/number_of_period/get_number_of_period.dart';
import '../../authentication/token/token_cubit.dart';

part 'net_worth_number_of_period_state.dart';

class NetWorthNumberOfPeriodCubit extends Cubit<NetWorthNumberOfPeriodState> {
  final GetNumberOfPeriod getNumberOfPeriod;
  final GetNetWorthSelectedNumberOfPeriod getNetWorthSelectedNumberOfPeriod;

  NetWorthNumberOfPeriodCubit({
    required this.getNumberOfPeriod,
    required this.getNetWorthSelectedNumberOfPeriod,
  })
      : super(NetWorthNumberOfPeriodInitial());

  Future<void> loadNetWorthNumberOfPeriod({required BuildContext context, required String tileName,NumberOfPeriodItem? favoriteNumberOfPeriodItemData}) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthNumberOfPeriodLoading());

    final Either<AppError, NumberOfPeriodEntity>
    eitherNumberOfPeriod =
    await getNumberOfPeriod(context);
    final NumberOfPeriodItemData? savedNumberOfPeriod = favoriteNumberOfPeriodItemData ?? await getNetWorthSelectedNumberOfPeriod(tileName);

    eitherNumberOfPeriod.fold(
          (error) {

      },
          (numberOfPeriodEntity) {

            List<NumberOfPeriodItemData> numberOfPeriodList = numberOfPeriodEntity.periodList;
            NumberOfPeriodItemData? selectedNumberOfPeriod = (numberOfPeriodEntity.periodList.isNotEmpty) ? numberOfPeriodEntity.periodList.last : null;

            if(savedNumberOfPeriod != null) {
              selectedNumberOfPeriod = numberOfPeriodList.firstWhere((numberOfPeriod) => numberOfPeriod.id == savedNumberOfPeriod.id);
              numberOfPeriodList.removeWhere((numberOfPeriod) => numberOfPeriod.id == selectedNumberOfPeriod?.id);
              numberOfPeriodList.insert(0, selectedNumberOfPeriod);
            }

        emit(NetWorthNumberOfPeriodLoaded(
            selectedNumberOfPeriod: selectedNumberOfPeriod,
            entityList: numberOfPeriodList.toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedNetWorthNumberOfPeriod({NumberOfPeriodItemData? selectedNumberOfPeriod}) async {
    List<NumberOfPeriodItemData> periodList = state.netWorthNumberOfPeriodList ?? [];

    emit(NetWorthNumberOfPeriodInitial());
    emit(NetWorthNumberOfPeriodLoaded(
        selectedNumberOfPeriod: selectedNumberOfPeriod,
        entityList: periodList.toSet().toList()
    ));
  }
}
