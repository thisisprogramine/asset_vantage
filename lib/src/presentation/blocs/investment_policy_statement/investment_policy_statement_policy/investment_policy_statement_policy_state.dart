part of 'investment_policy_statement_policy_cubit.dart';

abstract class InvestmentPolicyStatementPolicyState extends Equatable {
  final Policies? selectedPolicy;

  const InvestmentPolicyStatementPolicyState({
    this.selectedPolicy
  });

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementPolicyInitial extends InvestmentPolicyStatementPolicyState {
  final Policies? selectPolicy;

  const InvestmentPolicyStatementPolicyInitial({
    this.selectPolicy,
  }) : super(
      selectedPolicy: selectPolicy
  );
}

class InvestmentPolicyStatementPolicyChanged extends InvestmentPolicyStatementPolicyState {
  final Policies? selectPolicy;

  const InvestmentPolicyStatementPolicyChanged({
    required this.selectPolicy,
  }) : super(
      selectedPolicy: selectPolicy
  );
}

class InvestmentPolicyStatementPolicyError extends InvestmentPolicyStatementPolicyState {
  final String message;

  const InvestmentPolicyStatementPolicyError(this.message);

  @override
  List<Object> get props => [message];
}