part of 'dashboard_datepicker_cubit.dart';

abstract class DashboardDatePickerState extends Equatable {
  final String? asOnDate;

  const DashboardDatePickerState({
    this.asOnDate
  });

  @override
  List<Object> get props => [];
}

class DashboardDateInitial extends DashboardDatePickerState {
  final String? date;

  const DashboardDateInitial({
    this.date,
  }) : super(
      asOnDate: date
  );
}

class DashboardDateChanged extends DashboardDatePickerState {
  final String date;

  const DashboardDateChanged({
    required this.date,
  }) : super(
    asOnDate: date,
  );
}

class DashboardDateError extends DashboardDatePickerState {
  final String message;

  const DashboardDateError(this.message);

  @override
  List<Object> get props => [message];
}