part of 'performance_primary_grouping_cubit.dart';

abstract class PerformancePrimaryGroupingState extends Equatable {
  final GroupingEntity? selectedGrouping;
  final List<GroupingEntity?>? groupingList;
  const PerformancePrimaryGroupingState({this.groupingList, this.selectedGrouping});

  @override
  List<Object> get props => [];
}

class PerformancePrimaryGroupingInitial extends PerformancePrimaryGroupingState {}

class PerformancePrimaryGroupingLoaded extends PerformancePrimaryGroupingState {
  final List<GroupingEntity?>? primaryGroupingList;
  final GroupingEntity? selectedPrimaryGrouping;
  const PerformancePrimaryGroupingLoaded({
    required this.primaryGroupingList,
    required this.selectedPrimaryGrouping,
  }) :super(selectedGrouping: selectedPrimaryGrouping, groupingList: primaryGroupingList);

  @override
  List<Object> get props => [];
}

class PerformancePrimaryGroupingError extends PerformancePrimaryGroupingState {
  final AppErrorType errorType;

  const PerformancePrimaryGroupingError({
    required this.errorType,
  });
}

class PerformancePrimaryGroupingLoading extends PerformancePrimaryGroupingState {
  const PerformancePrimaryGroupingLoading();
}
