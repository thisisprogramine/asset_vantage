part of 'investment_policy_statement_sub_grouping_cubit.dart';

abstract class InvestmentPolicyStatementSubGroupingState extends Equatable {
  final List<SubGroupingItemData> subGroupingSelectedItems;

  const InvestmentPolicyStatementSubGroupingState({
    required this.subGroupingSelectedItems,
  });

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementSubGroupingInitial
    extends InvestmentPolicyStatementSubGroupingState {
  final List<SubGroupingItemData> selectedItems;
  const InvestmentPolicyStatementSubGroupingInitial(
      {required this.selectedItems})
      : super(subGroupingSelectedItems: selectedItems);
}

class InvestmentPolicyStatementSubGroupingChanged
    extends InvestmentPolicyStatementSubGroupingState {
  final List<SubGroupingItemData> selectedItems;

  const InvestmentPolicyStatementSubGroupingChanged({
    required this.selectedItems,
  }) : super(subGroupingSelectedItems: selectedItems);

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementSubGroupingError
    extends InvestmentPolicyStatementSubGroupingState {
  final AppErrorType errorType;

  InvestmentPolicyStatementSubGroupingError({
    required this.errorType,
  }) : super(subGroupingSelectedItems: []);
}
