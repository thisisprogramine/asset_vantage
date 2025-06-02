part of 'performance_primary_sub_grouping_cubit.dart';

abstract class PerformancePrimarySubGroupingState extends Equatable {
  final List<SubGroupingItemData?>? selectedSubGroupingList;
  final List<SubGroupingItemData?>? subGroupingList;
  const PerformancePrimarySubGroupingState({
    this.selectedSubGroupingList, this.subGroupingList,
  });

  @override
  List<Object> get props => [];
}

class PerformancePrimarySubGroupingInitial extends PerformancePrimarySubGroupingState {}

class PerformancePrimarySubGroupingLoaded extends PerformancePrimarySubGroupingState {
  final List<SubGroupingItemData?>? selectedSecondarySubGroupingList;
  final List<SubGroupingItemData?>? secondarySubGroupingList;
  const PerformancePrimarySubGroupingLoaded({
    required this.selectedSecondarySubGroupingList, required this.secondarySubGroupingList,
  })
      : super(selectedSubGroupingList: selectedSecondarySubGroupingList, subGroupingList: secondarySubGroupingList);

  @override
  List<Object> get props => [];
}

class PerformancePrimarySubGroupingError extends PerformancePrimarySubGroupingState {
  final AppErrorType errorType;

  const PerformancePrimarySubGroupingError({
    required this.errorType,
  }) : super();
}

class PerformancePrimarySubGroupingLoading extends PerformancePrimarySubGroupingState {
  const PerformancePrimarySubGroupingLoading()
      : super();
}
