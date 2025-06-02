part of 'dashboard_filter_cubit.dart';

abstract class DashboardFilterState extends Equatable {
  final List<EntityData>? filterList;
  final EntityData? selectedFilter;
  final List<EntityData>? originalList;

  const DashboardFilterState({
    this.filterList,
    this.selectedFilter,
    this.originalList,
  });

  @override
  List<Object> get props => [];
}

class DashboardFilterInitial extends DashboardFilterState {
  final List<EntityData>? list;
  final EntityData? selectFilter;
  final List<EntityData>? origList;

  const DashboardFilterInitial({
    this.list,
    this.selectFilter,
    this.origList,
  }) : super(
    filterList: list,
    selectedFilter: selectFilter,
    originalList: origList
  );
}

class DashboardFilterChanged extends DashboardFilterState {
  final List<EntityData>? list;
  final EntityData? selectFilter;
  final List<EntityData>? origList;

  const DashboardFilterChanged({
    required this.list,
    required this.selectFilter,
    required this.origList,
  }) : super(
    filterList: list,
    selectedFilter: selectFilter,
    originalList: origList
  );
}

class DashboardFilterLoading extends DashboardFilterState {}

class DashboardFilterError extends DashboardFilterState {
  final AppErrorType errorType;
  final String message;

  const DashboardFilterError(this.message, this.errorType);

  @override
  List<Object> get props => [message];
}