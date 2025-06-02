
import 'package:asset_vantage/src/data/models/dashboard/dashboard_entity_model.dart';
import 'package:asset_vantage/src/domain/usecases/universal_filters/clear_all_the_filters.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_report/income_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../performance/performance_report/performance_report_cubit.dart';

class UniversalFilterCubit extends Cubit<bool> {
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final ClearAllTheFilters clearAllTheFilters;

  UniversalFilterCubit({required this.clearAllTheFilters, required this.universalEntityFilterCubit, required this.universalFilterAsOnDateCubit})
      : super(false);

  Future<void> resetAllTheFilters({
    required BuildContext context,
    required NetWorthReportCubit netWorthReportCubit,
    required PerformanceReportCubit performanceReportCubit,
    required CashBalanceReportCubit cashBalanceReportCubit,
    required IncomeReportCubit incomeReportCubit,
    required ExpenseReportCubit expenseReportCubit,
  }) async {
    await clearAllTheFilters();

    netWorthReportCubit.loadNetWorthReport(
        context: context, tileName: 'NetWorth',
      universalEntity: Entity(
        id: universalEntityFilterCubit.state.selectedUniversalEntity?.id,
        name: universalEntityFilterCubit.state.selectedUniversalEntity?.name,
        type: universalEntityFilterCubit.state.selectedUniversalEntity?.type,
        currency: universalEntityFilterCubit.state.selectedUniversalEntity?.currency,
        accountingyear: universalEntityFilterCubit.state.selectedUniversalEntity?.accountingyear
      ),
      universalAsOnDate: universalFilterAsOnDateCubit.state.asOnDate
    );

    performanceReportCubit.loadPerformanceReport(context: context,
        universalEntity: Entity(
            id: universalEntityFilterCubit.state.selectedUniversalEntity?.id,
            name: universalEntityFilterCubit.state.selectedUniversalEntity?.name,
            type: universalEntityFilterCubit.state.selectedUniversalEntity?.type,
            currency: universalEntityFilterCubit.state.selectedUniversalEntity?.currency,
            accountingyear: universalEntityFilterCubit.state.selectedUniversalEntity?.accountingyear
        ),
        universalAsOnDate: universalFilterAsOnDateCubit.state.asOnDate,
        tileName: "Performance"
    );

    cashBalanceReportCubit.loadCashBalanceReport(context: context, tileName: 'cash_balance',
        universalEntity: Entity(
            id: universalEntityFilterCubit.state.selectedUniversalEntity?.id,
            name: universalEntityFilterCubit.state.selectedUniversalEntity?.name,
            type: universalEntityFilterCubit.state.selectedUniversalEntity?.type,
            currency: universalEntityFilterCubit.state.selectedUniversalEntity?.currency,
            accountingyear: universalEntityFilterCubit.state.selectedUniversalEntity?.accountingyear
        ),
        universalAsOnDate: universalFilterAsOnDateCubit.state.asOnDate
    );

    incomeReportCubit.loadIncomeReport(context: context,
        universalEntity: Entity(
            id: universalEntityFilterCubit.state.selectedUniversalEntity?.id,
            name: universalEntityFilterCubit.state.selectedUniversalEntity?.name,
            type: universalEntityFilterCubit.state.selectedUniversalEntity?.type,
            currency: universalEntityFilterCubit.state.selectedUniversalEntity?.currency,
            accountingyear: universalEntityFilterCubit.state.selectedUniversalEntity?.accountingyear
        ),
        universalAsOnDate: universalFilterAsOnDateCubit.state.asOnDate
    );

    expenseReportCubit.loadExpenseReport(context: context,
        universalEntity: Entity(
            id: universalEntityFilterCubit.state.selectedUniversalEntity?.id,
            name: universalEntityFilterCubit.state.selectedUniversalEntity?.name,
            type: universalEntityFilterCubit.state.selectedUniversalEntity?.type,
            currency: universalEntityFilterCubit.state.selectedUniversalEntity?.currency,
            accountingyear: universalEntityFilterCubit.state.selectedUniversalEntity?.accountingyear
        ),
        universalAsOnDate: universalFilterAsOnDateCubit.state.asOnDate
    );

  }
}