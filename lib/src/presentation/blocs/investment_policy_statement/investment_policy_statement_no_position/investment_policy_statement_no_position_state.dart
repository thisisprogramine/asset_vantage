part of 'investment_policy_statement_no_position_cubit.dart';

abstract class InvestmentPolicyStatementNoPositionState extends Equatable {
  final bool show;

  const InvestmentPolicyStatementNoPositionState({
    required this.show,
  });

  @override
  List<Object> get props => [];
}

class InvestmentPolicyStatementNoPositionInitial
    extends InvestmentPolicyStatementNoPositionState {
  final bool show;
  const InvestmentPolicyStatementNoPositionInitial(
      {required this.show})
      : super(show: show);
}

class InvestmentPolicyStatementNoPositionChanged
    extends InvestmentPolicyStatementNoPositionState {
  final bool show;

  const InvestmentPolicyStatementNoPositionChanged({
    required this.show,
  }) : super(show: show);

  @override
  List<Object> get props => [];
}

