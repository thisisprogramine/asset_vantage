import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:equatable/equatable.dart';

abstract class NetWorthPartnershipMethodState extends Equatable{
  final PartnershipMethodItemData? selectedNetWorthPartnershipMethod;
  final List<PartnershipMethodItemData>? netWorthPartnershipMethodList;

  const NetWorthPartnershipMethodState({
    this.selectedNetWorthPartnershipMethod,
     this.netWorthPartnershipMethodList});

  @override
  List<Object?> get props => [];
}

class NetWorthPartnershipMethodInitial extends NetWorthPartnershipMethodState{}

class NetWorthPartnershipMethodLoaded extends NetWorthPartnershipMethodState{
  final PartnershipMethodItemData? selectedPartnershipMethod;
  final List<PartnershipMethodItemData>? partnershipMethodList;

  const NetWorthPartnershipMethodLoaded({
   required this.selectedPartnershipMethod,
    required this.partnershipMethodList}): super(
      selectedNetWorthPartnershipMethod: selectedPartnershipMethod,
    netWorthPartnershipMethodList: partnershipMethodList
  );

  @override
  List<Object> get props => [];
}

class NetWorthPartnershipMethod extends NetWorthPartnershipMethodState{
  final AppErrorType errorType;

  const NetWorthPartnershipMethod({
    required this.errorType});
}

class NetWorthPartnershipMethodLoading extends NetWorthPartnershipMethodState{
  const NetWorthPartnershipMethodLoading();
}