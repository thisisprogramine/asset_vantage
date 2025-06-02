part of 'net_worth_period_cubit.dart';

abstract class NetWorthPeriodState extends Equatable {
  final PeriodItemData? selectedNetWorthPeriod;
  final List<PeriodItemData>? netWorthPeriodList;
  const NetWorthPeriodState({this.selectedNetWorthPeriod, this.netWorthPeriodList});

  @override
  List<Object> get props => [];
}

class NetWorthPeriodInitial extends NetWorthPeriodState {}

class NetWorthPeriodLoaded extends NetWorthPeriodState {
  final PeriodItemData? selectedPeriod;
  final List<PeriodItemData>? entityList;
  const NetWorthPeriodLoaded({
    required this.entityList,
    required this.selectedPeriod,
  }) :super(selectedNetWorthPeriod: selectedPeriod, netWorthPeriodList: entityList);

  @override
  List<Object> get props => [];
}

class NetWorthPeriodError extends NetWorthPeriodState {
  final AppErrorType errorType;

  const NetWorthPeriodError({
    required this.errorType,
  });
}

class NetWorthPeriodLoading extends NetWorthPeriodState {
  const NetWorthPeriodLoading();
}
