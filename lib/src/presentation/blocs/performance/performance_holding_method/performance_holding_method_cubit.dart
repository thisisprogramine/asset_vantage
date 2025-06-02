import 'package:asset_vantage/src/data/models/partnership_method/holding_method_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/holding_method/get_holding_method.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_holding_method/get_performance_selected_holding_method.dart';
import '../../authentication/token/token_cubit.dart';

class PerformanceHoldingMethodCubit extends Cubit<PerformanceHoldingMethodState>{
  final GetHoldingMethod getHoldingMethod;
  final GetPerformanceSelectedHoldingMethod getPerformanceSelectedHoldingMethod;

  PerformanceHoldingMethodCubit({
    required this.getHoldingMethod,
    required this.getPerformanceSelectedHoldingMethod}):super(
    PerformanceHoldingMethodInitial()
  );

  Future<void> loadPerformanceHoldingMethod({
    required BuildContext context, required String tileName,
    HoldingMethodItem? favoriteHoldingMethodItemData   })async {

    context.read<TokenCubit>().checkIfTokenExpired();
    emit(PerformanceHoldingMethodInitial());

    final Either<AppError,HoldingMethodEntities> eitherHoldingMethod = await getHoldingMethod(context);
    final HoldingMethodItemData? savedHoldingMethod = favoriteHoldingMethodItemData ?? await getPerformanceSelectedHoldingMethod(tileName);

    eitherHoldingMethod.fold((error){

    }, (holdingMethodEntity){
      List<HoldingMethodItemData> holdingMethodList = holdingMethodEntity.holdingMethodList;
      HoldingMethodItemData? selectedHoldingMethod = (holdingMethodEntity.holdingMethodList.isNotEmpty) ? holdingMethodEntity.holdingMethodList.first : null;
      if(savedHoldingMethod != null){
        selectedHoldingMethod= holdingMethodList.firstWhere((holdingMethod)=>holdingMethod.id == savedHoldingMethod.id);
        holdingMethodList.removeWhere((holdingMethod)=>holdingMethod.id == selectedHoldingMethod?.id);
        holdingMethodList.insert(0, selectedHoldingMethod);
      }
      emit(PerformanceHoldingMethodLoaded(
          selectedHoldingMethod: selectedHoldingMethod,
          holdingMethodList: holdingMethodList.toSet().toList()));
    });
  }

  Future<void> changeSelectedPerformanceHoldingMethod({HoldingMethodItemData? selectedHoldingMethod}) async{
    List<HoldingMethodItemData> holdingList = state.performanceHoldingList ?? [];

    emit(PerformanceHoldingMethodInitial());
    emit(PerformanceHoldingMethodLoaded(
        selectedHoldingMethod: selectedHoldingMethod,
        holdingMethodList: holdingList.toSet().toList()));

  }
}