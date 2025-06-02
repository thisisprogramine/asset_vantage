part of 'universal_filter_as_on_date_cubit.dart';

abstract class UniversalFilterAsOnDateState extends Equatable {
  final String? asOnDate;

  const UniversalFilterAsOnDateState({
    this.asOnDate
  });

  @override
  List<Object> get props => [];
}

class AsOnDateInitial extends UniversalFilterAsOnDateState {
  final String? date;

  const AsOnDateInitial({
    this.date,
  }) : super(
      asOnDate: date
  );
}

class AsOnDateChanged extends UniversalFilterAsOnDateState {
  final String date;

  const AsOnDateChanged({
    required this.date,
  }) : super(
    asOnDate: date,
  );
}

class AsOnDateError extends UniversalFilterAsOnDateState {
  final String message;

  const AsOnDateError(this.message);

  @override
  List<Object> get props => [message];
}