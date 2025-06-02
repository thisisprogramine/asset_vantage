part of 'performance_secondary_sub_grouping_cubit.dart';

abstract class PerformanceSecondarySubGroupingState extends Equatable {
  final List<SubGroupingItemData?>? selectedSubGroupingList;
  final List<SubGroupingItemData?>? subGroupingList;
  const PerformanceSecondarySubGroupingState({
    this.selectedSubGroupingList, this.subGroupingList,
  });

  @override
  List<Object> get props => [];
}

class PerformanceSecondarySubGroupingInitial extends PerformanceSecondarySubGroupingState {}

class PerformanceSecondarySubGroupingLoaded extends PerformanceSecondarySubGroupingState {
  final List<SubGroupingItemData?>? selectedSecondarySubGroupingList;
  final List<SubGroupingItemData?>? secondarySubGroupingList;
  const PerformanceSecondarySubGroupingLoaded({
    required this.selectedSecondarySubGroupingList, required this.secondarySubGroupingList,
  })
      : super(selectedSubGroupingList: selectedSecondarySubGroupingList, subGroupingList: secondarySubGroupingList);

  @override
  List<Object> get props => [];
}

class PerformanceSecondarySubGroupingError extends PerformanceSecondarySubGroupingState {
  final AppErrorType errorType;

  const PerformanceSecondarySubGroupingError({
    required this.errorType,
  }) : super();
}

class PerformanceSecondarySubGroupingLoading extends PerformanceSecondarySubGroupingState {
  const PerformanceSecondarySubGroupingLoading()
      : super();
}
