import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/app_error.dart';

class NetWorthHoldingMethodState extends Equatable{
  // final List<Map<String,String>>? holdingMethodList;
  // final Map<String,String>? selectedHoldingMethod;
  //
  // const NetWorthHoldingMethodState( {
  //    this.holdingMethodList =  const [],
  //    this.selectedHoldingMethod});
  //
  // @override
  // List<Object?> get props => [holdingMethodList,selectedHoldingMethod];

  final HoldingMethodItemData? selectedNetworthHoldingMethod;
  final List<HoldingMethodItemData>? networthHoldingList;

  const NetWorthHoldingMethodState({
     this.selectedNetworthHoldingMethod,
     this.networthHoldingList});

  @override
  List<Object?> get props => [];

}

class NetWorthHoldingMethodInital extends NetWorthHoldingMethodState{}

class NetWorthHoldingMethodLoaded extends NetWorthHoldingMethodState{
  final HoldingMethodItemData? selectedHoldingMethod;
  final List<HoldingMethodItemData>? holdingMethodList;

  const NetWorthHoldingMethodLoaded({
    required this.selectedHoldingMethod,
    required this.holdingMethodList}): super(
    selectedNetworthHoldingMethod: selectedHoldingMethod,
    networthHoldingList: holdingMethodList
  );

  @override
  List<Object> get props => [];
}
class NetWorthHoldingMethodError extends NetWorthHoldingMethodState{
  final AppErrorType errorType;

  const NetWorthHoldingMethodError({
    required this.errorType});
}

class NetWorthHoldingMethodLoading extends NetWorthHoldingMethodState{
  const NetWorthHoldingMethodLoading();
}
