import 'package:asset_vantage/src/config/constants/holding_method_constants.dart';
import 'package:asset_vantage/src/data/models/partnership_method/holding_method_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/usecases/holding_method/get_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_holding_method/get_net_worth_selected_holding_method.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/token/token_cubit.dart';

class NetWorthHoldingMethodCubit extends Cubit<NetWorthHoldingMethodState>{

  // NetWorthHoldingMethodCubit(): super(const NetWorthHoldingMethodState());
  //
  // void selectHoldingMethod(Map<String,String>? selectedMethod){
  //   if(state.holdingMethodList!.contains(selectedMethod)){
  //     emit(NetWorthHoldingMethodState(
  //       holdingMethodList: state.holdingMethodList,
  //       selectedHoldingMethod: selectedMethod
  //     ));
  //   }
  // }
  //
  // void loadHoldingMethods(){
  //   final List<Map<String,String>> methods = List<Map<String,String>>.from(HoldingMethodConstants.data["result"]!);
  //
  //   final Map<String,String>? initialSelection = methods.isNotEmpty ? methods.first :null;
  //   emit(NetWorthHoldingMethodState(
  //     holdingMethodList: methods,
  //     selectedHoldingMethod: initialSelection
  //   ));
  // }
  final GetHoldingMethod getHoldingMethod;
  final GetNetWorthSelectedHoldingMethod getNetWorthSelectedHoldingMethod;

  NetWorthHoldingMethodCubit({
    required this.getHoldingMethod,
    required this.getNetWorthSelectedHoldingMethod}):super(
    NetWorthHoldingMethodInital()
  );

  Future<void> loadNetWorthHoldingMethod({
    required BuildContext context, required String tileName,
    HoldingMethodItem? favoriteHoldingMethodItemData })async{

    context.read<TokenCubit>().checkIfTokenExpired();
    emit(NetWorthHoldingMethodInital());

    final Either<AppError,HoldingMethodEntities> eitherHoldingMethod = await getHoldingMethod(context);
    final HoldingMethodItemData? savedHoldingMethod = favoriteHoldingMethodItemData ?? await getNetWorthSelectedHoldingMethod(tileName);

    eitherHoldingMethod.fold((error){

    }, (holdingMethodEntity){
      List<HoldingMethodItemData> holdingMethodList = holdingMethodEntity.holdingMethodList;
      HoldingMethodItemData? selectedHoldingMethod = (holdingMethodEntity.holdingMethodList.isNotEmpty) ? holdingMethodEntity.holdingMethodList.first : null;
      if(savedHoldingMethod != null){
        selectedHoldingMethod= holdingMethodList.firstWhere((holdingMethod)=>holdingMethod.id == savedHoldingMethod.id);
        holdingMethodList.removeWhere((holdingMethod)=>holdingMethod.id == selectedHoldingMethod?.id);
        holdingMethodList.insert(0, selectedHoldingMethod);
      }
      emit(NetWorthHoldingMethodLoaded(
          selectedHoldingMethod: selectedHoldingMethod,
          holdingMethodList: holdingMethodList.toSet().toList()));
    });
  }

  Future<void> changeSelectedNetWorthHoldingMethod({HoldingMethodItemData? selectedHoldingMethod}) async{
    List<HoldingMethodItemData> holdingList = state.networthHoldingList ?? [];

    emit(NetWorthHoldingMethodInital());
    emit(NetWorthHoldingMethodLoaded(
        selectedHoldingMethod: selectedHoldingMethod,
        holdingMethodList: holdingList.toSet().toList()));

  }

}