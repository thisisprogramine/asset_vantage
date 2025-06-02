part of 'performance_return_percent_cubit.dart';

abstract class PerformanceReturnPercentState extends Equatable {
  final List<ReturnPercentItemData?>? selectedPerformanceReturnPercentList;
  final List<ReturnPercentItemData?>? performanceReturnPercentList;
  const PerformanceReturnPercentState({this.selectedPerformanceReturnPercentList, this.performanceReturnPercentList});

  @override
  List<Object> get props => [];
}

class PerformanceReturnPercentInitial extends PerformanceReturnPercentState {}

class PerformanceReturnPercentLoaded extends PerformanceReturnPercentState {
  final List<ReturnPercentItemData?>? selectedReturnPercentList;
  final List<ReturnPercentItemData?>? returnPercentList;
  const PerformanceReturnPercentLoaded({
    required this.returnPercentList,
    required this.selectedReturnPercentList,
  }) :super(selectedPerformanceReturnPercentList: selectedReturnPercentList, performanceReturnPercentList: returnPercentList);

  @override
  List<Object> get props => [];
}

class PerformanceReturnPercentError extends PerformanceReturnPercentState {
  final AppErrorType errorType;

  const PerformanceReturnPercentError({
    required this.errorType,
  });
}

class PerformanceReturnPercentLoading extends PerformanceReturnPercentState {
  const PerformanceReturnPercentLoading();
}
