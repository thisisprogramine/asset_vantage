import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_grouping_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_policies_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_report_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_sub_grouping_model.dart';
import 'package:asset_vantage/src/data/models/investment_policy_statement/investment_policy_statement_time_period_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/chart_data.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_report_params.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_sub_grouping_params.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_time_period_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_policies.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_report.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_sub_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_time_period.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'investment_policy_statement_test.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<GetInvestmentPolicyStatementGrouping>()])
@GenerateMocks([],
    customMocks: [MockSpec<GetInvestmentPolicyStatementPolicies>()])
@GenerateMocks([],
    customMocks: [MockSpec<GetInvestmentPolicyStatementSubGrouping>()])
@GenerateMocks([],
    customMocks: [MockSpec<GetInvestmentPolicyStatementTimePeriod>()])
@GenerateMocks([],
    customMocks: [MockSpec<GetInvestmentPolicyStatementReport>()])
void main() async {
  group('Investment Policy Statement test', () {
    test(
        'InvestmentPolicyStatementGroupingEntity should be return on success api call',
        () async {
      final getInvestmentPolicyStatementGrouping =
          MockGetInvestmentPolicyStatementGrouping();

      when(getInvestmentPolicyStatementGrouping(NoParams())).thenAnswer(
          (_) async => const Right(InvestmentPolicyStatementGroupingEntity(
              groupingList: [Grouping(id: 0, name: '')])));

      final result = await getInvestmentPolicyStatementGrouping(NoParams());

      InvestmentPolicyStatementGroupingModel.fromJson({});
      InvestmentPolicyStatementGroupingModel().toJson();
      PrimaryGrouping.fromJson({});
      const PrimaryGrouping().toJson();

      result.fold((error) {
        expect(error, isA<InvestmentPolicyStatementGroupingEntity>());
      }, (response) {
        response.props;
        response.groupingList.first.props;
        expect(response, isA<InvestmentPolicyStatementGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getInvestmentPolicyStatementGrouping =
          MockGetInvestmentPolicyStatementGrouping();

      when(getInvestmentPolicyStatementGrouping(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getInvestmentPolicyStatementGrouping(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test(
        'InvestmentPolicyStatementPoliciesEntity should be return on success api call',
        () async {
      final getInvestmentPolicyStatementPolicies =
          MockGetInvestmentPolicyStatementPolicies();

      when(getInvestmentPolicyStatementPolicies(NoParams())).thenAnswer(
          (_) async => const Right(InvestmentPolicyStatementPoliciesEntity(
              policyList: [Policies(id: 0, policyname: '')])));

      final result = await getInvestmentPolicyStatementPolicies(NoParams());
      InvestmentPolicyStatementPoliciesModel.fromJson(const {});
      // InvestmentPolicyStatementPoliciesModel().toJson();
      PolicyModel.fromJson({});
      PolicyModel().toJson();
      result.fold((error) {
        expect(error, isA<InvestmentPolicyStatementPoliciesEntity>());
      }, (response) {
        response.props;
        response.policyList.first.props;
        expect(response, isA<InvestmentPolicyStatementPoliciesEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getInvestmentPolicyStatementPolicies =
          MockGetInvestmentPolicyStatementPolicies();

      when(getInvestmentPolicyStatementPolicies(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getInvestmentPolicyStatementPolicies(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test(
        'InvestmentPolicyStatementSubGroupingEntity should be return on success api call',
        () async {
      final getInvestmentPolicyStatementSubGrouping =
          MockGetInvestmentPolicyStatementSubGrouping();

      when(getInvestmentPolicyStatementSubGrouping(
              const InvestmentPolicyStatementSubGroupingParams(
                  entity: '', subgrouping: '')))
          .thenAnswer((_) async => const Right(
              InvestmentPolicyStatementSubGroupingEntity(
                  subGroupingList: [SubGroupingItemData()])));

      final result = await getInvestmentPolicyStatementSubGrouping(
          const InvestmentPolicyStatementSubGroupingParams(
              entity: '', subgrouping: ''));

      InvestmentPolicyStatementSubGroupingParams(entity: '', subgrouping: '')
          .toJson();
      InvestmentPolicyStatementSubGroupingModel.fromJson({});
      InvestmentPolicyStatementSubGroupingModel().toJson();
      SubGroupingItem.fromJson({});
      const SubGroupingItem().toJson();
      result.fold((error) {
        expect(error, isA<InvestmentPolicyStatementSubGroupingEntity>());
      }, (response) {
        response.props;
        response.subGroupingList.first.props;
        expect(response, isA<InvestmentPolicyStatementSubGroupingEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getInvestmentPolicyStatementSubGrouping =
          MockGetInvestmentPolicyStatementSubGrouping();

      when(getInvestmentPolicyStatementSubGrouping(
              const InvestmentPolicyStatementSubGroupingParams(
                  entity: '', subgrouping: '')))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getInvestmentPolicyStatementSubGrouping(
          const InvestmentPolicyStatementSubGroupingParams(
              entity: '', subgrouping: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test(
        'InvestmentPolicyStatementTimePeriodEntity should be return on success api call',
        () async {
      final getInvestmentPolicyStatementTimePeriod =
          MockGetInvestmentPolicyStatementTimePeriod();

      when(getInvestmentPolicyStatementTimePeriod(
              const InvestmentPolicyStatementTimePeriodParams()))
          .thenAnswer((_) async => const Right(
              InvestmentPolicyStatementTimePeriodEntity(
                  timePeriodList: [TimePeriodItemData()])));

      final result = await getInvestmentPolicyStatementTimePeriod(
          const InvestmentPolicyStatementTimePeriodParams());

      const InvestmentPolicyStatementTimePeriodParams().toJson();
      InvestmentPolicyStatementTimePeriodModel.fromJson(const {});
      // const InvestmentPolicyStatementTimePeriodModel().toJson();
      TimePeriodItem.fromJson(const {});
      const TimePeriodItem().toJson();
      result.fold((error) {
        expect(error, isA<InvestmentPolicyStatementTimePeriodEntity>());
      }, (response) {
        response.props;
        response.timePeriodList?.first.props;
        expect(response, isA<InvestmentPolicyStatementTimePeriodEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getInvestmentPolicyStatementTimePeriod =
          MockGetInvestmentPolicyStatementTimePeriod();

      when(getInvestmentPolicyStatementTimePeriod(
              const InvestmentPolicyStatementTimePeriodParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getInvestmentPolicyStatementTimePeriod(
          const InvestmentPolicyStatementTimePeriodParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test(
        'InvestmentPolicyStatementReportEntity should be return on success api call',
        () async {
      final getInvestmentPolicyStatementReport =
          MockGetInvestmentPolicyStatementReport();

      when(getInvestmentPolicyStatementReport(
              const InvestmentPolicyStatementReportParams(
                  primaryfilter: '',
                  filter5: '',
                  policyid: '',
                  date: '',
                  yearReturn: '',
                  entity: '',
                  reportingCurrency: '')))
          .thenAnswer((_) async =>
              const Right(InvestmentPolicyStatementReportEntity(report: [
                InvestmentPolicyStatementReportData(
                    reportTitle: '',
                    allocation: 0.0,
                    expectedAllocation: 0.0,
                    returnPercent: 0.0,
                    benchmark: 0.0)
              ])));

      final result = await getInvestmentPolicyStatementReport(
          const InvestmentPolicyStatementReportParams(
              entity: '',
              primaryfilter: '',
              filter5: '',
              policyid: '',
              date: '',
              yearReturn: '',
              reportingCurrency: ''));

      InvestmentPolicyStatementReportParams(
              entity: '',
              primaryfilter: '',
              filter5: '',
              policyid: '',
              date: '',
              yearReturn: '',
          reportingCurrency: '')
          .toJson();
      InvestmentPolicyStatementReportModel.fromJson(const {});
      // InvestmentPolicyStatementReportModel().toJson();
      InvestmentPolicyModel.fromJson({});
      InvestmentPolicyModel(
        title: "",
        actualAllocation: 0.0,
        benchmarkReturn: 0.0,
        expectedAllocation: 0.0,
        returnPercent: 0.0,
      ).toJson();
      result.fold((error) {
        expect(error, isA<InvestmentPolicyStatementReportEntity>());
      }, (response) {
        const InvestmentPolicyStatementChartData();
        response.props;
        response.report.first.props;
        expect(response, isA<InvestmentPolicyStatementReportEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getInvestmentPolicyStatementReport =
          MockGetInvestmentPolicyStatementReport();

      when(getInvestmentPolicyStatementReport(
              const InvestmentPolicyStatementReportParams(
                  entity: '',
                  primaryfilter: '',
                  filter5: '',
                  policyid: '',
                  date: '',
                  yearReturn: '', reportingCurrency: '')))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getInvestmentPolicyStatementReport(
          const InvestmentPolicyStatementReportParams(
              entity: '',
              primaryfilter: '',
              filter5: '',
              policyid: '',
              date: '',
              yearReturn: '', reportingCurrency: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
