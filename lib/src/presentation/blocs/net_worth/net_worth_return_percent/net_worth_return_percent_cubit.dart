import 'package:asset_vantage/src/domain/params/net_worth/net_worth_return_percent_params.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/net_worth/net_worth_return_percent_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/net_worth/net_worth_return_percent_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/net_worth/get_net_worth_return_percent.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_return_percent/get_net_worth_selected_return_percent.dart';
import '../../authentication/token/token_cubit.dart';

part 'net_worth_return_percent_state.dart';

class NetWorthReturnPercentCubit extends Cubit<NetWorthReturnPercentState> {
  final GetNetWorthReturnPercent getReturnPercentage;
  final GetNetWorthSelectedReturnPercent getNetWorthSelectedReturnPercent;

  NetWorthReturnPercentCubit({
    required this.getReturnPercentage,
    required this.getNetWorthSelectedReturnPercent,
  })
      : super(NetWorthReturnPercentInitial());

  Future<void> loadNetWorthReturnPercent({required BuildContext context, ReturnPercentItem? favoriteReturnPercentItem}) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthReturnPercentLoading());

    final Either<AppError, NetWorthReturnPercentEntity>
    eitherReturnPercent =
    await getReturnPercentage(NetWorthReturnPercentParams(context: context));
    final ReturnPercentItem? savedReturnPercentage = favoriteReturnPercentItem ?? await getNetWorthSelectedReturnPercent();

    eitherReturnPercent.fold(
          (error) {

      },
          (returnPercentageEntity) {

            List<ReturnPercentItemData> returnPercentList = returnPercentageEntity.returnPercentList;
            ReturnPercentItemData? selectedReturnPercent = (returnPercentageEntity.returnPercentList.isNotEmpty) ? returnPercentageEntity.returnPercentList.first : null;

            if(savedReturnPercentage != null) {
              selectedReturnPercent = returnPercentList.firstWhere((numberOfPeriod) => numberOfPeriod.id == selectedReturnPercent?.id);
              returnPercentList.removeWhere((numberOfPeriod) => numberOfPeriod.id == selectedReturnPercent?.id);
              returnPercentList.insert(0, selectedReturnPercent);
            }

            emit(NetWorthReturnPercentInitial());
            emit(NetWorthReturnPercentLoaded(
                selectedReturnPercent: selectedReturnPercent,
                returnPercentList: returnPercentList.toSet().toList()
            ));
      },
    );
  }

  Future<void> changeSelectedNetWorthReturnPercent({required ReturnPercentItemData? selectedReturnPercent}) async {
    List<ReturnPercentItemData?> returnPercentList = state.netWorthReturnPercentList ?? [];


    emit(NetWorthReturnPercentInitial());
    emit(NetWorthReturnPercentLoaded(
        selectedReturnPercent: selectedReturnPercent,
        returnPercentList: returnPercentList.toSet().toList()
    ));
  }
}
