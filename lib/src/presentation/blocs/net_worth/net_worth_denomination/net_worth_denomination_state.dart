part of 'net_worth_denomination_cubit.dart';

abstract class NetWorthDenominationState extends Equatable {
  final DenominationData? selectedNetWorthDenomination;
  final List<DenominationData?>? netWorthDenominationList;
  const NetWorthDenominationState({this.selectedNetWorthDenomination, this.netWorthDenominationList});

  @override
  List<Object> get props => [];
}

class NetWorthDenominationInitial extends NetWorthDenominationState {}

class NetWorthDenominationLoaded extends NetWorthDenominationState {
  final DenominationData? selectedDenomination;
  final List<DenominationData?>? entityList;
  const NetWorthDenominationLoaded({
    required this.entityList,
    required this.selectedDenomination,
  }) :super(selectedNetWorthDenomination: selectedDenomination, netWorthDenominationList: entityList);

  @override
  List<Object> get props => [];
}

class NetWorthDenominationError extends NetWorthDenominationState {
  final AppErrorType errorType;

  const NetWorthDenominationError({
    required this.errorType,
  });
}

class NetWorthDenominationLoading extends NetWorthDenominationState {
  const NetWorthDenominationLoading();
}
