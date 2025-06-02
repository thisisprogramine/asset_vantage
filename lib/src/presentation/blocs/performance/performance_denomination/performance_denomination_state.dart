part of 'performance_denomination_cubit.dart';

abstract class PerformanceDenominationState extends Equatable {
  final DenominationData? selectedPerformanceDenomination;
  final List<DenominationData?>? performanceDenominationList;
  const PerformanceDenominationState({this.selectedPerformanceDenomination, this.performanceDenominationList});

  @override
  List<Object> get props => [];
}

class PerformanceDenominationInitial extends PerformanceDenominationState {}

class PerformanceDenominationLoaded extends PerformanceDenominationState {
  final DenominationData? selectedDenomination;
  final List<DenominationData?>? entityList;
  const PerformanceDenominationLoaded({
    required this.entityList,
    required this.selectedDenomination,
  }) :super(selectedPerformanceDenomination: selectedDenomination, performanceDenominationList: entityList);

  @override
  List<Object> get props => [];
}

class PerformanceDenominationError extends PerformanceDenominationState {
  final AppErrorType errorType;

  const PerformanceDenominationError({
    required this.errorType,
  });
}

class PerformanceDenominationLoading extends PerformanceDenominationState {
  const PerformanceDenominationLoading();
}
