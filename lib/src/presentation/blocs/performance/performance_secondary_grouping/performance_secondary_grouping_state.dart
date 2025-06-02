part of 'performance_secondary_grouping_cubit.dart';

abstract class PerformanceSecondaryGroupingState extends Equatable {
  final GroupingEntity? selectedGrouping;
  final List<GroupingEntity?>? groupingList;
  const PerformanceSecondaryGroupingState({this.groupingList, this.selectedGrouping});

  @override
  List<Object> get props => [];
}

class PerformanceSecondaryGroupingInitial extends PerformanceSecondaryGroupingState {}

class PerformanceSecondaryGroupingLoaded extends PerformanceSecondaryGroupingState {
  final List<GroupingEntity?>? secondaryGroupingList;
  final GroupingEntity? selectedSecondaryGrouping;
  const PerformanceSecondaryGroupingLoaded({
    required this.secondaryGroupingList,
    required this.selectedSecondaryGrouping
  }) :super(selectedGrouping: selectedSecondaryGrouping, groupingList: secondaryGroupingList);

  @override
  List<Object> get props => [];
}

class PerformanceSecondaryGroupingError extends PerformanceSecondaryGroupingState {
  final AppErrorType errorType;

  const PerformanceSecondaryGroupingError({
    required this.errorType,
  });
}

class PerformanceSecondaryGroupingLoading extends PerformanceSecondaryGroupingState {
  const PerformanceSecondaryGroupingLoading();
}
