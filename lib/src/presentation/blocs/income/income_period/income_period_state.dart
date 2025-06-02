part of 'income_period_cubit.dart';

abstract class IncomePeriodState extends Equatable {
  final PeriodItemData? selectedIncomePeriod;
  final List<PeriodItemData?>? incomePeriodList;
  const IncomePeriodState({this.selectedIncomePeriod, this.incomePeriodList});

  @override
  List<Object> get props => [];
}

class IncomePeriodInitial extends IncomePeriodState {}

class IncomePeriodLoaded extends IncomePeriodState {
  final PeriodItemData? selectedPeriod;
  final List<PeriodItemData?>? entityList;
  const IncomePeriodLoaded({
    required this.entityList,
    required this.selectedPeriod,
  }) :super(selectedIncomePeriod: selectedPeriod, incomePeriodList: entityList);

  @override
  List<Object> get props => [];
}

class IncomePeriodError extends IncomePeriodState {
  final AppErrorType errorType;

  const IncomePeriodError({
    required this.errorType,
  });
}

class IncomePeriodLoading extends IncomePeriodState {
  const IncomePeriodLoading();
}
