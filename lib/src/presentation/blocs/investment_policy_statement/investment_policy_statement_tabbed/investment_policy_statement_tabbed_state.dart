part of 'investment_policy_statement_tabbed_cubit.dart';

abstract class InvestmentPolicyStatementTabbedState extends Equatable {
  final int currentTabIndex;
  final Grouping? selectedGrouping;
  final InvestmentPolicyStatementSubGroupingEntity? subGroupingEntity;
  final InvestmentPolicyStatementTimePeriodEntity? timePeriodEntity;
  final InvestmentPolicyStatementPoliciesEntity? policyEntity;

  const InvestmentPolicyStatementTabbedState({
    this.currentTabIndex = 0,
    this.selectedGrouping,
    this.subGroupingEntity,
    this.policyEntity,
    this.timePeriodEntity
  });

  @override
  List<Object> get props => [currentTabIndex];
}

class InvestmentPolicyStatementTabbedInitial extends InvestmentPolicyStatementTabbedState {}

class InvestmentPolicyStatementTabChanged extends InvestmentPolicyStatementTabbedState {
  final Grouping? selectedGrouping;
  final InvestmentPolicyStatementSubGroupingEntity? subGroupingEntity;
  final InvestmentPolicyStatementTimePeriodEntity? timePeriodEntity;
  final InvestmentPolicyStatementPoliciesEntity? policyEntity;
  const InvestmentPolicyStatementTabChanged({int currentTabIndex = 0, required this.selectedGrouping, required this.subGroupingEntity, required this.timePeriodEntity, required this.policyEntity})
      : super(
      currentTabIndex: currentTabIndex,
    selectedGrouping: selectedGrouping,
    subGroupingEntity: subGroupingEntity,
    policyEntity: policyEntity,
    timePeriodEntity: timePeriodEntity,
  );

  @override
  List<Object> get props => [currentTabIndex];
}

class InvestmentPolicyStatementTabbedError extends InvestmentPolicyStatementTabbedState {
  final AppErrorType errorType;

  const InvestmentPolicyStatementTabbedError({
    int currentTabIndex = 0,
    required this.errorType,
  }) : super(currentTabIndex: currentTabIndex);
}

class InvestmentPolicyStatementTabbedLoading extends InvestmentPolicyStatementTabbedState {
  const InvestmentPolicyStatementTabbedLoading({int currentTabIndex = 0})
      : super(currentTabIndex: currentTabIndex);
}
