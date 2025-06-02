import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/app_error.dart';

class PerformanceHoldingMethodState extends Equatable{
  final HoldingMethodItemData? selectedPerformanceHoldingMethod;
  final List<HoldingMethodItemData>? performanceHoldingList;

  const PerformanceHoldingMethodState({
     this.selectedPerformanceHoldingMethod,
     this.performanceHoldingList});

  @override
  List<Object?> get props => [];

}

class PerformanceHoldingMethodInitial extends PerformanceHoldingMethodState{}

class PerformanceHoldingMethodLoaded extends PerformanceHoldingMethodState{
  final HoldingMethodItemData? selectedHoldingMethod;
  final List<HoldingMethodItemData>? holdingMethodList;

  const PerformanceHoldingMethodLoaded({
  required this.selectedHoldingMethod,
    required this.holdingMethodList}):super(
    selectedPerformanceHoldingMethod: selectedHoldingMethod,
    performanceHoldingList: holdingMethodList
  );

  @override
  List<Object> get props => [];
}

class PerformanceHoldingMethodError extends PerformanceHoldingMethodState{
  final AppErrorType errorType;

  const PerformanceHoldingMethodError({
    required this.errorType});
}

class PerformanceHoldingMethodLoading extends PerformanceHoldingMethodState{
  const PerformanceHoldingMethodLoading();
}