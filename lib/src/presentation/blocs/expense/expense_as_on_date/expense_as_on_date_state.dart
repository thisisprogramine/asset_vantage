part of 'expense_as_on_date_cubit.dart';

abstract class ExpenseAsOnDateState extends Equatable {
  final String? asOnDate;

  const ExpenseAsOnDateState({
    this.asOnDate
  });

  @override
  List<Object> get props => [];
}

class AsOnDateInitial extends ExpenseAsOnDateState {
  final String? date;

  const AsOnDateInitial({
    this.date,
  }) : super(
      asOnDate: date
  );
}

class AsOnDateChanged extends ExpenseAsOnDateState {
  final String date;

  const AsOnDateChanged({
    required this.date,
  }) : super(
    asOnDate: date,
  );
}

class AsOnDateError extends ExpenseAsOnDateState {
  final String message;

  const AsOnDateError(this.message);

  @override
  List<Object> get props => [message];
}