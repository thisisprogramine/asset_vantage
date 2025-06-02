part of 'performance_number_of_period_cubit.dart';

abstract class PerformanceNumberOfPeriodState extends Equatable {
  final NumberOfPeriodItemData? selectedPerformanceNumberOfPeriod;
  final List<NumberOfPeriodItemData>? performanceNumberOfPeriodList;
  const PerformanceNumberOfPeriodState({this.selectedPerformanceNumberOfPeriod, this.performanceNumberOfPeriodList});

  @override
  List<Object> get props => [];
}

class PerformanceNumberOfPeriodInitial extends PerformanceNumberOfPeriodState {}

class PerformanceNumberOfPeriodLoaded extends PerformanceNumberOfPeriodState {
  final NumberOfPeriodItemData? selectedNumberOfPeriod;
  final List<NumberOfPeriodItemData>? entityList;
  const PerformanceNumberOfPeriodLoaded({
    required this.entityList,
    required this.selectedNumberOfPeriod,
  }) :super(selectedPerformanceNumberOfPeriod: selectedNumberOfPeriod, performanceNumberOfPeriodList: entityList);

  @override
  List<Object> get props => [];
}

class PerformanceNumberOfPeriodError extends PerformanceNumberOfPeriodState {
  final AppErrorType errorType;

  const PerformanceNumberOfPeriodError({
    required this.errorType,
  });
}

class PerformanceNumberOfPeriodLoading extends PerformanceNumberOfPeriodState {
  const PerformanceNumberOfPeriodLoading();
}
