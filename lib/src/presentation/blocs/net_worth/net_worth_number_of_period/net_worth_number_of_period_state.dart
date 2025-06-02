part of 'net_worth_number_of_period_cubit.dart';

abstract class NetWorthNumberOfPeriodState extends Equatable {
  final NumberOfPeriodItemData? selectedNetWorthNumberOfPeriod;
  final List<NumberOfPeriodItemData>? netWorthNumberOfPeriodList;
  const NetWorthNumberOfPeriodState({this.selectedNetWorthNumberOfPeriod, this.netWorthNumberOfPeriodList});

  @override
  List<Object> get props => [];
}

class NetWorthNumberOfPeriodInitial extends NetWorthNumberOfPeriodState {}

class NetWorthNumberOfPeriodLoaded extends NetWorthNumberOfPeriodState {
  final NumberOfPeriodItemData? selectedNumberOfPeriod;
  final List<NumberOfPeriodItemData>? entityList;
  const NetWorthNumberOfPeriodLoaded({
    required this.entityList,
    required this.selectedNumberOfPeriod,
  }) :super(selectedNetWorthNumberOfPeriod: selectedNumberOfPeriod, netWorthNumberOfPeriodList: entityList);

  @override
  List<Object> get props => [];
}

class NetWorthNumberOfPeriodError extends NetWorthNumberOfPeriodState {
  final AppErrorType errorType;

  const NetWorthNumberOfPeriodError({
    required this.errorType,
  });
}

class NetWorthNumberOfPeriodLoading extends NetWorthNumberOfPeriodState {
  const NetWorthNumberOfPeriodLoading();
}
