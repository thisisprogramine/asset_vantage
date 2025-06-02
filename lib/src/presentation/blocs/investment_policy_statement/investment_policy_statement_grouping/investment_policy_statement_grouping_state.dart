part of 'investment_policy_statement_grouping_cubit.dart';

abstract class InvestmentPolicyStatementGroupingState extends Equatable {
  final InvestmentPolicyStatementGroupingEntity? groupingEntity;
  const InvestmentPolicyStatementGroupingState({this.groupingEntity});

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementGroupingInitial extends InvestmentPolicyStatementGroupingState {}

class InvestmentPolicyStatementGroupingLoaded extends InvestmentPolicyStatementGroupingState {
  final InvestmentPolicyStatementGroupingEntity grouping;
  const InvestmentPolicyStatementGroupingLoaded({
    required this.grouping
  }) :super(groupingEntity: grouping);

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementGroupingError extends InvestmentPolicyStatementGroupingState {
  final AppErrorType errorType;

  const InvestmentPolicyStatementGroupingError({
    required this.errorType,
  });
}

class InvestmentPolicyStatementGroupingLoading extends InvestmentPolicyStatementGroupingState {
  const InvestmentPolicyStatementGroupingLoading();
}
