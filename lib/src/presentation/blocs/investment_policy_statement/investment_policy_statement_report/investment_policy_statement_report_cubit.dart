

import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/chart_data.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_report_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_report.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_time_period/investment_policy_statement_time_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_timestamp/investment_policy_statement_timestamp_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/preferences/user_preference.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../authentication/login_check/login_check_cubit.dart';
import '../../loading/loading_cubit.dart';

part 'investment_policy_statement_report_state.dart';

class InvestmentPolicyStatementReportCubit extends Cubit<InvestmentPolicyStatementReportState> {
  final LoadingCubit loadingCubit;
  final InvestmentPolicyStatementTimePeriodCubit investmentPolicyStatementTimePeriodCubit;
  final GetInvestmentPolicyStatementReport getInvestmentPolicyStatementReport;
  final GetUserPreference getUserPreference;
  final InvestmentPolicyStatementTimestampCubit investmentPolicyStatementTimestampCubit;
  final LoginCheckCubit loginCheckCubit;


  InvestmentPolicyStatementReportCubit({
    required this.loadingCubit,
    required this.investmentPolicyStatementTimePeriodCubit,
    required this.getInvestmentPolicyStatementReport,
    required this.getUserPreference,
    required this.investmentPolicyStatementTimestampCubit,
    required this.loginCheckCubit,
  }) : super(InvestmentPolicyStatementReportInitial());

  void loadInvestmentPolicyStatementReport({required BuildContext context,
    List<SubGroupingItemData>? subGrouping, List<TimePeriodItemData?>? timePeriod,
    Policies? selectedPolicy, Grouping? selectedGrouping, required EntityData? selectedEntity,
    String? asOnDate, required Currency? reportingCurrency,
  }) async{

    emit(const InvestmentPolicyStatementReportLoading());

    String formatedSubGrouping = '';

    subGrouping?.forEach((grp) {
      formatedSubGrouping = formatedSubGrouping + ('${grp.id},' ?? '');
    });

    investmentPolicyStatementTimePeriodCubit.selectYear1(selectedTimePeriod: timePeriod?.first);

    final Either<AppError, UserPreference> eitherUserPreference = await getUserPreference(NoParams());

    eitherUserPreference.fold((l) {

    }, (pref) async {
      final Either<AppError, InvestmentPolicyStatementReportEntity> eitherIPS = await getInvestmentPolicyStatementReport(InvestmentPolicyStatementReportParams(
        context: context,
          entityname: selectedEntity?.name,
          primaryfilter: selectedGrouping?.name,
          policyid: selectedPolicy?.id.toString(),
          filter5: formatedSubGrouping,
          date: asOnDate,
          yearReturn: timePeriod?.first?.id,
          reportingCurrency: reportingCurrency?.code,
          reportingCurrencyid: reportingCurrency?.id,
          primaryfilterid: selectedGrouping?.id.toString(),
          entitytype: selectedEntity?.type?.toLowerCase(),
          id: selectedEntity?.id.toString(),
          type: selectedEntity?.type?.toLowerCase(),
          currencycode: reportingCurrency?.code,
          currencyid: reportingCurrency?.id,
          accountingyear: selectedEntity?.accountingyear,
          purpose: pref.regionUrl
      ));

      eitherIPS.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(InvestmentPolicyStatementReportError(errorType: error.appErrorType));
      }, (investmentPolicyStatement) {
        getUserPreference(NoParams()).then((response) {
          response.fold((l) {

          }, (preference) {
            investmentPolicyStatementTimestampCubit.updateIPSTimestamp(timeStamp: preference.ipsTimeStamp);
          });
        });
        emit(InvestmentPolicyStatementReportLoaded(chartData: investmentPolicyStatement.report));
      });
    });
  }

}
