import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:equatable/equatable.dart';

class PerformancePartnershipMethodState extends Equatable{
  final PartnershipMethodItemData? selectedPerformancePartnershipMethod;
  final List<PartnershipMethodItemData>? performancePartnershipList;

 const PerformancePartnershipMethodState({
     this.selectedPerformancePartnershipMethod,
     this.performancePartnershipList});

  @override
  List<Object?> get props => [];

}

class PerformancePartnershipMethodInitial extends PerformancePartnershipMethodState{}

class PerformancePartnershipMethodLoaded extends PerformancePartnershipMethodState{
  final PartnershipMethodItemData? selectedPartnershipMethod;
  final List<PartnershipMethodItemData>? partnershipMethodList;

  const PerformancePartnershipMethodLoaded({
    required this.selectedPartnershipMethod,
    required this.partnershipMethodList}): super(
    selectedPerformancePartnershipMethod: selectedPartnershipMethod,
    performancePartnershipList: partnershipMethodList
  );

  @override
  List<Object> get props => [];
}

class PerformancePartnershipMethodError extends PerformancePartnershipMethodState{
  final AppErrorType errorType;

  const PerformancePartnershipMethodError({
   required this.errorType});
}

class PerformancePartnershipMethodLoading extends PerformancePartnershipMethodState{
  const PerformancePartnershipMethodLoading();
}