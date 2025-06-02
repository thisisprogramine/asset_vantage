part of 'investment_policy_statement_time_period_cubit.dart';

abstract class InvestmentPolicyStatementTimePeriodState extends Equatable {
  final TimePeriodItemData? timePeriodSelectedItem;

  const InvestmentPolicyStatementTimePeriodState({
    this.timePeriodSelectedItem
  });

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementTimePeriodInitial extends InvestmentPolicyStatementTimePeriodState {
  final TimePeriodItemData? selectedItem;

  const InvestmentPolicyStatementTimePeriodInitial({
    this.selectedItem,
  }) : super(
      timePeriodSelectedItem: selectedItem
  );
}

class InvestmentPolicyStatementTimePeriodChanged extends InvestmentPolicyStatementTimePeriodState {
  final TimePeriodItemData? selectedItem;

  const InvestmentPolicyStatementTimePeriodChanged({
    required this.selectedItem,
  }) : super(
      timePeriodSelectedItem: selectedItem
  );
}

class InvestmentPolicyStatementTimePeriodError extends InvestmentPolicyStatementTimePeriodState {
  final String message;

  const InvestmentPolicyStatementTimePeriodError(this.message);

  @override
  List<Object> get props => [message];
}