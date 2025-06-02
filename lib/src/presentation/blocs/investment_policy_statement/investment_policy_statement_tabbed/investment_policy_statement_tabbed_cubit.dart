import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_policies.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_sub_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_time_period.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_policy/investment_policy_statement_policy_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_sub_grouping/investment_policy_statement_sub_grouping_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../../../domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import '../../../../domain/params/investment_policy_statement/investment_policy_statement_sub_grouping_params.dart';
import '../../../../domain/params/investment_policy_statement/investment_policy_statement_time_period_params.dart';
import '../../../../domain/params/investment_policy_statement/ips_get_filter_params.dart';
import '../../../../domain/usecases/investment_policy_statement/get_ips_policy_filter.dart';
import '../../../../domain/usecases/investment_policy_statement/get_ips_return_filter.dart';
import '../../../../domain/usecases/investment_policy_statement/get_ips_sub_filter.dart';
import '../../authentication/login_check/login_check_cubit.dart';

part 'investment_policy_statement_tabbed_state.dart';

class InvestmentPolicyStatementTabbedCubit
    extends Cubit<InvestmentPolicyStatementTabbedState> {
  final GetInvestmentPolicyStatementSubGrouping
      getInvestmentPolicyStatementSubGrouping;
  final GetInvestmentPolicyStatementPolicies
  getInvestmentPolicyStatementPolicies;
  final GetInvestmentPolicyStatementTimePeriod
      getInvestmentPolicyStatementTimePeriod;
  final InvestmentPolicyStatementReportCubit
      investmentPolicyStatementReportCubit;
  final InvestmentPolicyStatementSubGroupingCubit
      investmentPolicyStatementSubGroupingCubit;
  final InvestmentPolicyStatementPolicyCubit
  investmentPolicyStatementPolicyCubit;
  final GetIpsReturnFilter getIpsReturnFilter;
  final GetIpsSubFilter getIpsSubFilter;
  final GetIpsPolicyFilter getIpsPolicyFilter;
  final LoginCheckCubit loginCheckCubit;

  InvestmentPolicyStatementTabbedCubit(
      {required this.getInvestmentPolicyStatementSubGrouping,
      required this.getInvestmentPolicyStatementPolicies,
      required this.getInvestmentPolicyStatementTimePeriod,
      required this.investmentPolicyStatementReportCubit,
      required this.investmentPolicyStatementSubGroupingCubit,
        required this.loginCheckCubit,
      required this.investmentPolicyStatementPolicyCubit,
        required this.getIpsReturnFilter,
        required this.getIpsSubFilter,
        required this.getIpsPolicyFilter,
      })
      : super(InvestmentPolicyStatementTabbedInitial());

  Future<void> tabChanged({
    required BuildContext context,
    int currentTabIndex = 0,
    required Grouping? selectedGrouping,
    required EntityData? selectedEntity,
    required String? asOnDate,
    required Currency? reportingCurrency
  }) async {
    emit(InvestmentPolicyStatementTabbedLoading(
        currentTabIndex: currentTabIndex));

    final policyFil = await getSelectedPolicies(entityName: selectedEntity?.name, grouping: selectedGrouping?.name);
    final subFil = await getSelectedSubFilters(entityName: selectedEntity?.name, grouping: selectedGrouping?.name);
    final periodFil = await getSelectedTimePeriod(entityName: selectedEntity?.name, grouping: selectedGrouping?.name);

    final Either<AppError, InvestmentPolicyStatementSubGroupingEntity>
        eitherInvestmentPolicyStatementSubGrouping =
        await getInvestmentPolicyStatementSubGrouping(
            InvestmentPolicyStatementSubGroupingParams(
              context: context,
              entity: selectedEntity?.name,
                id: selectedEntity?.id.toString(),
              entitytype: selectedEntity?.type,
              subgrouping: selectedGrouping?.name
            ));

    eitherInvestmentPolicyStatementSubGrouping.fold((error) {
      if(error.appErrorType==AppErrorType.unauthorised){
        loginCheckCubit.loginCheck();
      }
      emit(InvestmentPolicyStatementTabbedError(
          currentTabIndex: currentTabIndex, errorType: error.appErrorType));
    }, (subGrouping) async {

      List<SubGroupingItemData>? tempSub;
      if(subFil!=null && subFil.isNotEmpty){
        tempSub = [...(subGrouping.subGroupingList)];
        subFil.forEach((element) {
          final index = tempSub?.indexWhere((ele) => ele.id==element.id);
          if(index!=null && index!=-1){
            tempSub?.removeAt(index);
            tempSub?.insert(0, element);
          }
        });
      }
      final hasSimilarItems = (tempSub?.where((element) => (subFil ?? []).any((ele) => ele.id==element.id)).toList() ?? [] );
      investmentPolicyStatementSubGroupingCubit.selectItemInFilter1(
          selectedFilter: tempSub!=null? hasSimilarItems.isNotEmpty? hasSimilarItems:tempSub :subGrouping.subGroupingList,grouping: selectedGrouping?.name,entityName: selectedEntity?.name);

      final Either<AppError, InvestmentPolicyStatementPoliciesEntity> eitherPolicies = await getInvestmentPolicyStatementPolicies(context);

      eitherPolicies.fold((error) {
        if(error.appErrorType==AppErrorType.unauthorised){
          loginCheckCubit.loginCheck();
        }
        emit(InvestmentPolicyStatementTabbedError(
            currentTabIndex: currentTabIndex, errorType: error.appErrorType));
          }, (policies) async{

        List<Policies>? tempPol;
        if(policyFil!=null){
          tempPol = [...(policies.policyList)];
          final index = tempPol.indexWhere((element) => element.id==policyFil.id);
          if(index!=null && index!=-1){
            tempPol.removeAt(index);
            tempPol.insert(0, policyFil);
          }
        }
        investmentPolicyStatementPolicyCubit.selectPolicy(selectedPolicy: tempPol!=null?tempPol.first: (policies.policyList.isNotEmpty ? policies.policyList[0] : null));

            final Either<AppError, InvestmentPolicyStatementTimePeriodEntity>
            eitherInvestmentPolicyStatementTimePeriod =
                await getInvestmentPolicyStatementTimePeriod(InvestmentPolicyStatementTimePeriodParams(context: context));

            eitherInvestmentPolicyStatementTimePeriod.fold((error) {
              emit(InvestmentPolicyStatementTabbedError(
                  currentTabIndex: currentTabIndex, errorType: error.appErrorType));
            }, (timePeriod) {
              List<TimePeriodItemData>? tempPeriod;
              if(periodFil!=null){
                tempPeriod = [...(timePeriod.timePeriodList ?? [])];
                final index = tempPeriod.indexWhere((element) => element.id==periodFil.id);
                if(index!=null && index!=-1){
                  tempPeriod.removeAt(index);
                  tempPeriod.insert(0, periodFil);
                }
              }
              emit(InvestmentPolicyStatementTabChanged(
                  currentTabIndex: currentTabIndex,
                  selectedGrouping: selectedGrouping,
                  subGroupingEntity: tempSub!=null? InvestmentPolicyStatementSubGroupingEntity(subGroupingList: tempSub):subGrouping,
                  policyEntity: tempPol!=null? InvestmentPolicyStatementPoliciesEntity(policyList: tempPol):policies,
                  timePeriodEntity:  tempPeriod!=null? InvestmentPolicyStatementTimePeriodEntity(timePeriodList: tempPeriod):timePeriod
              ));

              investmentPolicyStatementReportCubit
                  .loadInvestmentPolicyStatementReport(
                context: context,
                  subGrouping: tempSub ?? subGrouping.subGroupingList,
                  selectedPolicy: tempPol !=null ? tempPol.first: policies.policyList.isNotEmpty ? policies.policyList.first:null,
                  timePeriod: tempPeriod ?? timePeriod.timePeriodList,
                  selectedGrouping: selectedGrouping,
                  selectedEntity: selectedEntity,
                  asOnDate: asOnDate, reportingCurrency: reportingCurrency,
              );

            });
          });
          });

  }
  Future<Policies?> getSelectedPolicies({required String? entityName, required String? grouping,}) async {
    final Either<AppError, Policies?> policy = await getIpsPolicyFilter(GetIpsFilterParams(entityName: entityName, grouping: grouping));

    return policy.fold((error) {

      return null;
    }, (widget) {
      return widget;
    });
  }

  Future<TimePeriodItemData?> getSelectedTimePeriod({required String? entityName, required String? grouping,}) async {
    final Either<AppError, TimePeriodItemData?> period = await getIpsReturnFilter(GetIpsFilterParams(entityName: entityName, grouping: grouping));

    return period.fold((error) {

      return null;
    }, (widget) {
      return widget;
    });
  }

  Future<List<SubGroupingItemData>?> getSelectedSubFilters({required String? entityName, required String? grouping,}) async {
    final Either<AppError, List<SubGroupingItemData>?> filters = await getIpsSubFilter(GetIpsFilterParams(entityName: entityName, grouping: grouping));

    return filters.fold((error) {

      return null;
    }, (widget) {
      return widget;
    });
  }
}
