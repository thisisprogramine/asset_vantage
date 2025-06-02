part of 'net_worth_as_on_date_cubit.dart';

abstract class NetWorthAsOnDateState extends Equatable {
  final String? asOnDate;

  const NetWorthAsOnDateState({
    this.asOnDate
  });

  @override
  List<Object> get props => [];
}

class AsOnDateInitial extends NetWorthAsOnDateState {
  final String? date;

  const AsOnDateInitial({
    this.date,
  }) : super(
      asOnDate: date
  );
}

class AsOnDateChanged extends NetWorthAsOnDateState {
  final String date;

  const AsOnDateChanged({
    required this.date,
  }) : super(
    asOnDate: date,
  );
}

class AsOnDateError extends NetWorthAsOnDateState {
  final String message;

  const AsOnDateError(this.message);

  @override
  List<Object> get props => [message];
}