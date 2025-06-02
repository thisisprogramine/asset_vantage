part of 'income_number_of_period_cubit.dart';

abstract class IncomeNumberOfPeriodState extends Equatable {
  final NumberOfPeriodItemData? selectedIncomeNumberOfPeriod;
  final List<NumberOfPeriodItemData?>? incomeNumberOfPeriodList;
  const IncomeNumberOfPeriodState({this.selectedIncomeNumberOfPeriod, this.incomeNumberOfPeriodList});

  @override
  List<Object> get props => [];
}

class IncomeNumberOfPeriodInitial extends IncomeNumberOfPeriodState {}

class IncomeNumberOfPeriodLoaded extends IncomeNumberOfPeriodState {
  final NumberOfPeriodItemData? selectedNumberOfPeriod;
  final List<NumberOfPeriodItemData?>? entityList;
  const IncomeNumberOfPeriodLoaded({
    required this.entityList,
    required this.selectedNumberOfPeriod,
  }) :super(selectedIncomeNumberOfPeriod: selectedNumberOfPeriod, incomeNumberOfPeriodList: entityList);

  @override
  List<Object> get props => [];
}

class IncomeNumberOfPeriodError extends IncomeNumberOfPeriodState {
  final AppErrorType errorType;

  const IncomeNumberOfPeriodError({
    required this.errorType,
  });
}

class IncomeNumberOfPeriodLoading extends IncomeNumberOfPeriodState {
  const IncomeNumberOfPeriodLoading();
}
