

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'investment_policy_statement_no_position_state.dart';

class InvestmentPolicyNoPositionCubit extends Cubit<InvestmentPolicyStatementNoPositionState> {

  InvestmentPolicyNoPositionCubit()
      : super(const InvestmentPolicyStatementNoPositionInitial(show: false));

  void showNoPositionFound({required bool show}) async{

    await Future.delayed(const Duration(seconds: 1));

    emit(InvestmentPolicyStatementNoPositionInitial(show: show));
    emit(InvestmentPolicyStatementNoPositionChanged(show: show));
  }

}
