part of 'favourite_universal_filter_as_on_date_cubit.dart';

abstract class FavouriteUniversalFilterAsOnDateState extends Equatable {
  final String? asOnDate;

  const FavouriteUniversalFilterAsOnDateState({
    this.asOnDate
  });

  @override
  List<Object> get props => [];
}

class AsOnDateInitial extends FavouriteUniversalFilterAsOnDateState {
  final String? date;

  const AsOnDateInitial({
    this.date,
  }) : super(
      asOnDate: date
  );
}

class AsOnDateChanged extends FavouriteUniversalFilterAsOnDateState {
  final String date;

  const AsOnDateChanged({
    required this.date,
  }) : super(
    asOnDate: date,
  );
}

class AsOnDateError extends FavouriteUniversalFilterAsOnDateState {
  final String message;

  const AsOnDateError(this.message);

  @override
  List<Object> get props => [message];
}