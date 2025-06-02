part of 'net_worth_grouping_cubit.dart';

abstract class NetWorthPrimaryGroupingState extends Equatable {
  final GroupingEntity? selectedGrouping;
  final List<GroupingEntity?>? groupingList;
  const NetWorthPrimaryGroupingState({this.groupingList, this.selectedGrouping});

  @override
  List<Object> get props => [];
}

class NetWorthPrimaryGroupingInitial extends NetWorthPrimaryGroupingState {}

class NetWorthPrimaryGroupingLoaded extends NetWorthPrimaryGroupingState {
  final List<GroupingEntity?>? primaryGroupingList;
  final GroupingEntity? selectedPrimaryGrouping;
  const NetWorthPrimaryGroupingLoaded({
    required this.primaryGroupingList,
    required this.selectedPrimaryGrouping,
  }) :super(selectedGrouping: selectedPrimaryGrouping, groupingList: primaryGroupingList);

  @override
  List<Object> get props => [];
}

class NetWorthPrimaryGroupingError extends NetWorthPrimaryGroupingState {
  final AppErrorType errorType;

  const NetWorthPrimaryGroupingError({
    required this.errorType,
  });
}

class NetWorthPrimaryGroupingLoading extends NetWorthPrimaryGroupingState {
  const NetWorthPrimaryGroupingLoading();
}
