part of 'performance_as_on_date_cubit.dart';

abstract class PerformanceAsOnDateState extends Equatable {
  final String? asOnDate;

  const PerformanceAsOnDateState({
    this.asOnDate
  });

  @override
  List<Object> get props => [];
}

class AsOnDateInitial extends PerformanceAsOnDateState {
  final String? date;

  const AsOnDateInitial({
    this.date,
  }) : super(
      asOnDate: date
  );
}

class AsOnDateChanged extends PerformanceAsOnDateState {
  final String date;

  const AsOnDateChanged({
    required this.date,
  }) : super(
    asOnDate: date,
  );
}

class AsOnDateError extends PerformanceAsOnDateState {
  final String message;

  const AsOnDateError(this.message);

  @override
  List<Object> get props => [message];
}