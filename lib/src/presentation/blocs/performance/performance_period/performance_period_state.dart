part of 'performance_period_cubit.dart';

abstract class PerformancePeriodState extends Equatable {
  final PeriodItemData? selectedPerformancePeriod;
  final List<PeriodItemData>? performancePeriodList;
  const PerformancePeriodState({this.selectedPerformancePeriod, this.performancePeriodList});

  @override
  List<Object> get props => [];
}

class PerformancePeriodInitial extends PerformancePeriodState {}

class PerformancePeriodLoaded extends PerformancePeriodState {
  final PeriodItemData? selectedPeriod;
  final List<PeriodItemData>? entityList;
  const PerformancePeriodLoaded({
    required this.entityList,
    required this.selectedPeriod,
  }) :super(selectedPerformancePeriod: selectedPeriod, performancePeriodList: entityList);

  @override
  List<Object> get props => [];
}

class PerformancePeriodError extends PerformancePeriodState {
  final AppErrorType errorType;

  const PerformancePeriodError({
    required this.errorType,
  });
}

class PerformancePeriodLoading extends PerformancePeriodState {
  const PerformancePeriodLoading();
}
