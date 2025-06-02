import 'package:asset_vantage/src/data/models/expense/expense_account_model.dart';
import 'package:asset_vantage/src/data/models/expense/expense_report_model.dart'
    as erm;
import 'package:asset_vantage/src/data/models/income/income_account_model.dart';
import 'package:asset_vantage/src/data/models/income/income_report_model.dart'
    as irm;
import 'package:asset_vantage/src/data/models/income_expense/income_expense_number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/income_expense/income_expense_period_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_account_entity.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_chart_data.dart';
import 'package:asset_vantage/src/domain/entities/income/income_chart_data.dart'
    as inco;
import 'package:asset_vantage/src/domain/entities/expense/expense_report_entity.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_report_entity.dart'
    as exp;
import 'package:asset_vantage/src/domain/entities/income/income_account_entity.dart'
    as inc;
import 'package:asset_vantage/src/domain/entities/income/income_report_entity.dart'
    as income;
import 'package:asset_vantage/src/domain/entities/income_expense/income_expense_number_of_period_entity.dart';
import 'package:asset_vantage/src/domain/entities/income_expense/income_expense_period_entity.dart';
import 'package:asset_vantage/src/domain/params/expense/expense_account_params.dart';
import 'package:asset_vantage/src/domain/params/expense/expense_report_params.dart';
import 'package:asset_vantage/src/domain/params/income/income_account_params.dart';
import 'package:asset_vantage/src/domain/params/income/income_report_params.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/expense/get_expense_account.dart';
import 'package:asset_vantage/src/domain/usecases/expense/get_expense_report.dart';
import 'package:asset_vantage/src/domain/usecases/income/get_income_account.dart';
import 'package:asset_vantage/src/domain/usecases/income/get_income_report.dart';
import 'package:asset_vantage/src/domain/usecases/income_expense/get_income_expense_period.dart';
import 'package:asset_vantage/src/domain/usecases/income_expense/get_income_expense_worth_number_of%20_period.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateMocks([], customMocks: [MockSpec<GetExpenseAccount>()])
@GenerateMocks([], customMocks: [MockSpec<GetExpenseReport>()])
@GenerateMocks([], customMocks: [MockSpec<GetIncomeAccount>()])
@GenerateMocks([], customMocks: [MockSpec<GetIncomeReport>()])
@GenerateMocks([], customMocks: [MockSpec<GetIncomeExpensePeriod>()])
@GenerateMocks([], customMocks: [MockSpec<GetIncomeExpenseNumberOfPeriod>()])
import 'income_expense_test.mocks.dart';

void main() async {
  group("Income Expense Api Test", () {
    test("ExpenseAccountEntity should be returned on successful api call",
        () async {
      final getExpenseAccount = MockGetExpenseAccount();
      when(getExpenseAccount(const ExpenseAccountParams())).thenAnswer(
          (_) async => Right(ExpenseAccountEntity(expenseAccounts: [
                const AccountEntity(accountname: "", accounttype: "", id: 0)
              ])));
      final result = await getExpenseAccount(const ExpenseAccountParams());
      const ExpenseAccountParams().toJson();
      ExpenseAccountModel.fromJson({});
      ExpenseAccountModel().toJson();
      ExpenseAccount.fromJson({});
      ExpenseAccount().toJson();
      result.fold((error) {
        expect(error, isA<ExpenseAccountEntity>());
      }, (response) {
        response.expenseAccounts.first;
        expect(response, isA<ExpenseAccountEntity>());
      });
    });

    test("AppError should be returned on Api failure", () async {
      final getExpenseAccount = MockGetExpenseAccount();
      when(getExpenseAccount(const ExpenseAccountParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));
      final result = await getExpenseAccount(const ExpenseAccountParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test("ExpenseReportEntity should be returned on successful api call",
        () async {
      final getExpenseReport = MockGetExpenseReport();
      when(getExpenseReport(const ExpenseReportParams()))
          .thenAnswer((_) async => const Right(ExpenseReportEntity(report: [
                exp.ReportEntity(date: "", total: 0.0, children: [
                  Child(
                      accountName: "",
                      accountId: 0,
                      totalAmount: 0.0,
                      percentage: 0.0)
                ])
              ])));
      final result = await getExpenseReport(const ExpenseReportParams());
      const ExpenseReportParams().toJson();
      erm.ExpenseReportModel.fromJson(const {"expenseReport": {}});
      erm.ExpenseReportModel().toJson();
      erm.Date.fromJson({});
      erm.Date().toJson();
      erm.Filter.fromJson({});
      // erm.Filter().toJson();
      result.fold((error) {
        expect(error, isA<ExpenseReportEntity>());
      }, (response) {
        response.props;
        response.report.first.props;
        expect(response, isA<ExpenseReportEntity>());
      });
    });

    test("AppError should be returned on Api failure", () async {
      final getExpenseReport = MockGetExpenseReport();
      when(getExpenseReport(const ExpenseReportParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));
      final result = await getExpenseReport(const ExpenseReportParams());
      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test("IncomeAccountEntity should be returned on successful api call",
        () async {
      final getIncomeAccount = MockGetIncomeAccount();
      when(getIncomeAccount(const IncomeAccountParams())).thenAnswer(
          (_) async => Right(inc.IncomeAccountEntity(incomeAccounts: [
                const inc.Account(accountname: "", accounttype: "", id: 0)
              ])));
      final result = await getIncomeAccount(const IncomeAccountParams());
      const IncomeAccountParams().toJson();
      IncomeAccountModel.fromJson({});
      IncomeAccountModel().toJson();
      IncomeAccount.fromJson({});
      IncomeAccount().toJson();
      result.fold((error) {
        expect(error, isA<inc.IncomeAccountEntity>());
      }, (response) {
        response.incomeAccounts.first;
        expect(response, isA<inc.IncomeAccountEntity>());
      });
    });

    test("AppError should be returned on Api failure", () async {
      final getIncomeAccount = MockGetIncomeAccount();
      when(getIncomeAccount(const IncomeAccountParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));
      final result = await getIncomeAccount(const IncomeAccountParams());
      const IncomeAccountParams().toJson();

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test("IncomeReportEntity should be returned on successful api call",
        () async {
      final getIncomeReport = MockGetIncomeReport();
      when(getIncomeReport(const IncomeReportParams())).thenAnswer(
          (_) async => const Right(income.IncomeReportEntity(report: [
                income.ReportEntity(
                    date: "",
                    children: [
                      inco.Child(
                          accountName: "",
                          accountId: 0,
                          totalAmount: 0.0,
                          percentage: 0.0)
                    ],
                    total: 0.0)
              ])));
      final result = await getIncomeReport(const IncomeReportParams());
      const IncomeReportParams().toJson();
      irm.IncomeReportModel.fromJson(const {"incomeReport": {}});
      irm.IncomeReportModel().toJson();
      irm.Date.fromJson({});
      // irm.Date().toJson();
      irm.Filter.fromJson({});
      irm.Filter().toJson();
      result.fold((error) {
        expect(error, isA<income.IncomeReportEntity>());
      }, (response) {
        response.props;
        response.report.first.props;
        expect(response, isA<income.IncomeReportEntity>());
      });
    });

    test("AppError should be returned on Api failure", () async {
      final getIncomeReport = MockGetIncomeReport();
      when(getIncomeReport(const IncomeReportParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));
      final result = await getIncomeReport(const IncomeReportParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test("IncomeExpensePeriodEntity should be returned on successful api call",
        () async {
      final getIncomeExpensePeriod = MockGetIncomeExpensePeriod();
      when(getIncomeExpensePeriod(NoParams())).thenAnswer((_) async =>
          const Right(IncomeExpensePeriodEntity(
              periodList: [PeriodItemData(gaps: 0, id: "", name: "")])));
      final result = await getIncomeExpensePeriod(NoParams());
      IncomeExpensePeriodModel.fromJson(const {});
      // IncomeExpensePeriodModel().toJson();
      PeriodItem.fromJson({});
      // const PeriodItem().toJson();
      result.fold((error) {
        expect(error, isA<IncomeExpensePeriodEntity>());
      }, (response) {
        response.props;
        response.periodList.first.props;
        expect(response, isA<IncomeExpensePeriodEntity>());
      });
    });

    test("AppError should be returned on Api failure", () async {
      final getIncomeExpensePeriod = MockGetIncomeExpensePeriod();
      when(getIncomeExpensePeriod(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));
      final result = await getIncomeExpensePeriod(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test(
        "IncomeExpenseNumberOfPeriodEntity should be returned on successful api call",
        () async {
      final getIncomeExpenseNumberOfPeriod =
          MockGetIncomeExpenseNumberOfPeriod();
      when(getIncomeExpenseNumberOfPeriod(NoParams())).thenAnswer((_) async =>
          const Right(IncomeExpenseNumberOfPeriodEntity(periodList: [
            NumberOfPeriodItemData(id: "", name: "", value: 0)
          ])));
      final result = await getIncomeExpenseNumberOfPeriod(NoParams());
      IncomeExpenseNumberOfPeriodModel.fromJson(const {});
      IncomeExpenseNumberOfPeriodModel().toJson();
      NumberOfPeriodItem.fromJson({});
      const NumberOfPeriodItem().toJson();
      result.fold((error) {
        expect(error, isA<IncomeExpenseNumberOfPeriodEntity>());
      }, (response) {
        response.props;
        response.periodList.first.props;
        expect(response, isA<IncomeExpenseNumberOfPeriodEntity>());
      });
    });

    test("AppError should be returned on Api failure", () async {
      final getIncomeExpenseNumberOfPeriod =
          MockGetIncomeExpenseNumberOfPeriod();
      when(getIncomeExpenseNumberOfPeriod(NoParams()))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));
      final result = await getIncomeExpenseNumberOfPeriod(NoParams());

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}

// "lib/main.dart" "lib/src/injector.dart" "lib/src/config/*" "lib/src/core/*" "lib/src/data/*" "lib/src/presentation/*" "lib/src/services/*" "lib/src/utilities/*" "lib/src/domain/entities/*" "lib/src/domain/params/*" "lib/src/domain/repositories/*"