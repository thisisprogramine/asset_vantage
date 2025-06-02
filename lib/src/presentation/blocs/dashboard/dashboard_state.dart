part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();

}

class DashboardLoading extends DashboardState{}

class DashboardLoaded extends DashboardState {
  final List<WidgetData>? widgetList;

  const DashboardLoaded({
    required this.widgetList,
  });
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}