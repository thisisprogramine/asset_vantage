part of 'cash_balance_sub_grouping_cubit.dart';

abstract class CashBalancePrimarySubGroupingState extends Equatable {
  final List<SubGroupingItemData?>? selectedSubGroupingList;
  final List<SubGroupingItemData?>? subGroupingList;
  const CashBalancePrimarySubGroupingState({
    this.selectedSubGroupingList, this.subGroupingList,
  });

  @override
  List<Object> get props => [];
}

class CashBalancePrimarySubGroupingInitial extends CashBalancePrimarySubGroupingState {}

class CashBalancePrimarySubGroupingLoaded extends CashBalancePrimarySubGroupingState {
  final List<SubGroupingItemData?>? selectedSecondarySubGroupingList;
  final List<SubGroupingItemData?>? secondarySubGroupingList;
  const CashBalancePrimarySubGroupingLoaded({
    required this.selectedSecondarySubGroupingList, required this.secondarySubGroupingList,
  })
      : super(selectedSubGroupingList: selectedSecondarySubGroupingList, subGroupingList: secondarySubGroupingList);

  @override
  List<Object> get props => [];
}

class CashBalancePrimarySubGroupingError extends CashBalancePrimarySubGroupingState {
  final AppErrorType errorType;

  const CashBalancePrimarySubGroupingError({
    required this.errorType,
  }) : super();
}

class CashBalancePrimarySubGroupingLoading extends CashBalancePrimarySubGroupingState {
  const CashBalancePrimarySubGroupingLoading()
      : super();
}
