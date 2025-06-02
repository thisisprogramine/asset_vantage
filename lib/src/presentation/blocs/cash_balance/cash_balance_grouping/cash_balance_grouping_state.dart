part of 'cash_balance_grouping_cubit.dart';

abstract class CashBalancePrimaryGroupingState extends Equatable {
  final GroupingEntity? selectedGrouping;
  final List<GroupingEntity?>? groupingList;
  const CashBalancePrimaryGroupingState({this.groupingList, this.selectedGrouping});

  @override
  List<Object> get props => [];
}

class CashBalancePrimaryGroupingInitial extends CashBalancePrimaryGroupingState {}

class CashBalancePrimaryGroupingLoaded extends CashBalancePrimaryGroupingState {
  final List<GroupingEntity?>? primaryGroupingList;
  final GroupingEntity? selectedPrimaryGrouping;
  const CashBalancePrimaryGroupingLoaded({
    required this.primaryGroupingList,
    required this.selectedPrimaryGrouping,
  }) :super(selectedGrouping: selectedPrimaryGrouping, groupingList: primaryGroupingList);

  @override
  List<Object> get props => [];
}

class CashBalancePrimaryGroupingError extends CashBalancePrimaryGroupingState {
  final AppErrorType errorType;

  const CashBalancePrimaryGroupingError({
    required this.errorType,
  });
}

class CashBalancePrimaryGroupingLoading extends CashBalancePrimaryGroupingState {
  const CashBalancePrimaryGroupingLoading();
}
