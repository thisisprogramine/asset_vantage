part of 'dashboard_search_cubit.dart';

abstract class DashboardSearchState extends Equatable {

  const DashboardSearchState();

  @override
  List<Object> get props => [];
}

class DashboardSearchInitial extends DashboardSearchState {
  const DashboardSearchInitial();

}

class DashboardSearchLoaded extends DashboardSearchState {
  final List<WidgetData?> dashboardEntities;

  const DashboardSearchLoaded(this.dashboardEntities);
}

class DashboardSearchError extends DashboardSearchState {
  final String message;

  const DashboardSearchError(this.message);

  @override
  List<Object> get props => [message];
}