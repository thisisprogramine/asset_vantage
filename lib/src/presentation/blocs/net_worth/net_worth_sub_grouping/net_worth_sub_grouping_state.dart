part of 'net_worth_sub_grouping_cubit.dart';

abstract class NetWorthPrimarySubGroupingState extends Equatable {
  final List<SubGroupingItemData?>? selectedSubGroupingList;
  final List<SubGroupingItemData?>? subGroupingList;
  const NetWorthPrimarySubGroupingState({
    this.selectedSubGroupingList, this.subGroupingList,
  });

  @override
  List<Object> get props => [];
}

class NetWorthPrimarySubGroupingInitial extends NetWorthPrimarySubGroupingState {}

class NetWorthPrimarySubGroupingLoaded extends NetWorthPrimarySubGroupingState {
  final List<SubGroupingItemData?>? selectedSecondarySubGroupingList;
  final List<SubGroupingItemData?>? secondarySubGroupingList;
  const NetWorthPrimarySubGroupingLoaded({
    required this.selectedSecondarySubGroupingList, required this.secondarySubGroupingList,
  })
      : super(selectedSubGroupingList: selectedSecondarySubGroupingList, subGroupingList: secondarySubGroupingList);

  @override
  List<Object> get props => [];
}

class NetWorthPrimarySubGroupingError extends NetWorthPrimarySubGroupingState {
  final AppErrorType errorType;

  const NetWorthPrimarySubGroupingError({
    required this.errorType,
  }) : super();
}

class NetWorthPrimarySubGroupingLoading extends NetWorthPrimarySubGroupingState {
  const NetWorthPrimarySubGroupingLoading()
      : super();
}
