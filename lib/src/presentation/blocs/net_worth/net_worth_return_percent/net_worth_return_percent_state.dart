part of 'net_worth_return_percent_cubit.dart';

abstract class NetWorthReturnPercentState extends Equatable {
  final ReturnPercentItemData? selectedNetWorthReturnPercent;
  final List<ReturnPercentItemData?>? netWorthReturnPercentList;
  const NetWorthReturnPercentState({this.selectedNetWorthReturnPercent, this.netWorthReturnPercentList});

  @override
  List<Object> get props => [];
}

class NetWorthReturnPercentInitial extends NetWorthReturnPercentState {}

class NetWorthReturnPercentLoaded extends NetWorthReturnPercentState {
  final ReturnPercentItemData? selectedReturnPercent;
  final List<ReturnPercentItemData?>? returnPercentList;
  const NetWorthReturnPercentLoaded({
    required this.returnPercentList,
    required this.selectedReturnPercent,
  }) :super(selectedNetWorthReturnPercent: selectedReturnPercent, netWorthReturnPercentList: returnPercentList);

  @override
  List<Object> get props => [];
}

class NetWorthReturnPercentError extends NetWorthReturnPercentState {
  final AppErrorType errorType;

  const NetWorthReturnPercentError({
    required this.errorType,
  });
}

class NetWorthReturnPercentLoading extends NetWorthReturnPercentState {
  const NetWorthReturnPercentLoading();
}
