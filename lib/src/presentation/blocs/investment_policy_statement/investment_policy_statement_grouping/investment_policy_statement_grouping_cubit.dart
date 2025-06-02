
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_time_period_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/clear_investment_policy_statement.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_grouping.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../domain/params/investment_policy_statement/investment_policy_statement_report_params.dart';
import '../../../../domain/params/investment_policy_statement/investment_policy_statement_sub_grouping_params.dart';
import '../../../../domain/usecases/investment_policy_statement/get_investment_policy_statement_policies.dart';
import '../../../../domain/usecases/investment_policy_statement/get_investment_policy_statement_report.dart';
import '../../../../domain/usecases/investment_policy_statement/get_investment_policy_statement_sub_grouping.dart';
import '../../../../domain/usecases/investment_policy_statement/get_investment_policy_statement_time_period.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'investment_policy_statement_grouping_state.dart';

class InvestmentPolicyStatementGroupingCubit
    extends Cubit<InvestmentPolicyStatementGroupingState> {
  final GetInvestmentPolicyStatementGrouping
      getInvestmentPolicyStatementGrouping;
  final ClearInvestmentPolicyStatement
  clearInvestmentPolicyStatement;
  final GetInvestmentPolicyStatementSubGrouping
  getInvestmentPolicyStatementSubGrouping;
  final GetInvestmentPolicyStatementPolicies
  getInvestmentPolicyStatementPolicies;
  final GetInvestmentPolicyStatementTimePeriod
  getInvestmentPolicyStatementTimePeriod;
  final GetInvestmentPolicyStatementReport getInvestmentPolicyStatementReport;
  final LoginCheckCubit loginCheckCubit;
  final InvestmentPolicyStatementTabbedCubit investmentPolicyStatementTabbedCubit;

  InvestmentPolicyStatementGroupingCubit({
    required this.getInvestmentPolicyStatementGrouping,
    required this.investmentPolicyStatementTabbedCubit,
    required this.clearInvestmentPolicyStatement,
    required this.getInvestmentPolicyStatementSubGrouping,
    required this.getInvestmentPolicyStatementPolicies,
    required this.getInvestmentPolicyStatementTimePeriod,
    required this.getInvestmentPolicyStatementReport,
    required this.loginCheckCubit,
  })
      : super(InvestmentPolicyStatementGroupingInitial());

  Future<void> loadInvestmentPolicyStatementGrouping({bool shouldClearData = false, int? currentTabIndex, EntityData? selectedEntity,
        String? asOnDate, Currency? reportingCurrency, required BuildContext context}) async {

    emit(const InvestmentPolicyStatementGroupingLoading());

    if(shouldClearData) {
      await clearInvestmentPolicyStatement(NoParams());
    }

    final Either<AppError, InvestmentPolicyStatementGroupingEntity>
        eitherInvestmentPolicyStatementGrouping =
        await getInvestmentPolicyStatementGrouping(context);

    eitherInvestmentPolicyStatementGrouping.fold(
      (error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        return emit(InvestmentPolicyStatementGroupingError(
            errorType: error.appErrorType));
      },
      (grouping) async{

        investmentPolicyStatementTabbedCubit.tabChanged(
            context: context,
            currentTabIndex: currentTabIndex ?? 0,
            selectedGrouping: grouping.groupingList.isNotEmpty ? grouping.groupingList[currentTabIndex ?? 0] : null,
            selectedEntity: selectedEntity,
            asOnDate: asOnDate,
          reportingCurrency: reportingCurrency
        );
        emit(InvestmentPolicyStatementGroupingLoaded(grouping: grouping));


      },
    );
  }
}
