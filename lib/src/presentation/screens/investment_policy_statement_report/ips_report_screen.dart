
import 'package:asset_vantage/src/config/app_config.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/data/models/cash_balance/cash_balance_grouping_model.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/blocs/currency_filter/currency_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_sub_grouping/investment_policy_statement_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_time_period/investment_policy_statement_time_period_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../config/constants/size_constants.dart';
import '../../arguments/investment_policy_statement_argument.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_no_position/investment_policy_statement_no_position_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_policy/investment_policy_statement_policy_cubit.dart';
import '../../blocs/investment_policy_statement/investment_policy_statement_timestamp/investment_policy_statement_timestamp_cubit.dart';
import '../../widgets/av_app_bar.dart';
import '../../widgets/reporting_currency_filter.dart';
import 'chart_widget.dart';
import 'filter_widget.dart';
import 'item_widget_list.dart';

class IPSReportScreen extends StatefulWidget {
  final InvestmentPolicyStatementArgument argument;

  const IPSReportScreen({
    Key? key,
    required this.argument
  }) : super(key: key);

  @override
  State<IPSReportScreen> createState() => _IPSReportScreenState();
}

class _IPSReportScreenState extends State<IPSReportScreen> {
  late InvestmentPolicyStatementTabbedCubit investmentPolicyStatementTabbedCubit;
  late InvestmentPolicyStatementTimestampCubit investmentPolicyStatementTimestampCubit;
  late InvestmentPolicyStatementReportCubit investmentPolicyStatementReportCubit;
  late InvestmentPolicyStatementSubGroupingCubit investmentPolicyStatementSubGroupingCubit;
  late InvestmentPolicyStatementTimePeriodCubit investmentPolicyStatementTimePeriodCubit;
  late InvestmentPolicyStatementGroupingCubit investmentPolicyStatementGroupingCubit;
  late InvestmentPolicyNoPositionCubit investmentPolicyNoPositionCubit;
  late InvestmentPolicyStatementPolicyCubit investmentPolicyStatementPolicyCubit;

  @override
  void initState() {
    super.initState();
    currentTile = ReportTile.ipsAssetClass;
    investmentPolicyStatementGroupingCubit = getItInstance<InvestmentPolicyStatementGroupingCubit>();
    investmentPolicyNoPositionCubit = getItInstance<InvestmentPolicyNoPositionCubit>();
    investmentPolicyStatementTabbedCubit = investmentPolicyStatementGroupingCubit.investmentPolicyStatementTabbedCubit;
    investmentPolicyStatementPolicyCubit = investmentPolicyStatementTabbedCubit.investmentPolicyStatementPolicyCubit;
    investmentPolicyStatementSubGroupingCubit = investmentPolicyStatementTabbedCubit.investmentPolicyStatementSubGroupingCubit;
    investmentPolicyStatementReportCubit = investmentPolicyStatementTabbedCubit.investmentPolicyStatementReportCubit;
    investmentPolicyStatementTimestampCubit = investmentPolicyStatementReportCubit.investmentPolicyStatementTimestampCubit;
    investmentPolicyStatementTimePeriodCubit = investmentPolicyStatementTabbedCubit.investmentPolicyStatementReportCubit.investmentPolicyStatementTimePeriodCubit;
    context.read<CurrencyFilterCubit>().loadCurrencies(context: context, tileName: 'Investment-Policy-Statement', selectedEntity: widget.argument.entityData).then((value) {
      investmentPolicyStatementGroupingCubit.loadInvestmentPolicyStatementGrouping(
        context: context,
          selectedEntity: widget.argument.entityData,
          asOnDate: widget.argument.asOnDate,
          reportingCurrency: context.read<CurrencyFilterCubit>().state.selectedIPSCurrency,
      );
    });

  }

  @override
  void dispose() {
    super.dispose();
    investmentPolicyStatementTabbedCubit.close();
    investmentPolicyStatementReportCubit.close();
    investmentPolicyStatementGroupingCubit.close();
    investmentPolicyStatementTimePeriodCubit.close();
    investmentPolicyStatementSubGroupingCubit.close();
    investmentPolicyNoPositionCubit.close();
    investmentPolicyStatementPolicyCubit.close();
    investmentPolicyStatementTimestampCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => investmentPolicyStatementTabbedCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyStatementReportCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyStatementGroupingCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyStatementTimePeriodCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyStatementSubGroupingCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyNoPositionCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyStatementPolicyCubit,
        ),
        BlocProvider(
          create: (context) => investmentPolicyStatementTimestampCubit,
        ),
      ],
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: SafeArea(
          bottom: false,
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return OrientationBuilder(
                builder: (context, orientation) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgPicture.asset('assets/svgs/bg_graphics.svg',
                          width: ScreenUtil().screenWidth,
                          color: AppColor.grey.withOpacity(0.6),
                        ),
                      ),
                      Column(
                        children: [
                          AVAppBar(
                            elevation: true,
                            title: 'Investment Policy',
                            actions: [
                              Flexible(
                                child: BlocBuilder<CurrencyFilterCubit, CurrencyFilterState>(
                                    builder: (context,currencyState) {
                                      return GestureDetector(
                                        onTap: () {
                                          showCupertinoModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return CurrencyFilter(
                                                  items: context.read<CurrencyFilterCubit>().state.currencyFilterList,
                                                  investmentPolicyStatementTabbedCubit: investmentPolicyStatementTabbedCubit,
                                                  type: ReportType.IPS,
                                                selectedEntity: widget.argument.entityData,
                                                asOnDate: widget.argument.asOnDate,
                                                  investmentPolicyStatementGroupingCubit: investmentPolicyStatementGroupingCubit,
                                                  tileName: 'Investment-Policy-Statement'
                                              );
                                            },
                                          );
                                        },
                                        child: Card(
                                          margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w, vertical: Sizes.dimen_4.h),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)
                                              )
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.0),
                                                border: Border.all(color: context.read<AppThemeCubit>().state?.card?.color != null ? Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)) : AppColor.vulcan)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(currencyState.selectedIPSCurrency?.code ?? '--', style: Theme.of(context).textTheme.titleSmall),
                                                        Icon(Icons.arrow_drop_down_outlined, color: context.read<AppThemeCubit>().state?.filter?.iconColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!)) : AppColor.primary, size: Sizes.dimen_24.w,)
                                                      ],
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: CustomScrollView(
                              scrollBehavior: const CupertinoScrollBehavior(),
                              slivers: [
                                CupertinoSliverRefreshControl(
                                  onRefresh: () async{
                                    await investmentPolicyStatementGroupingCubit.loadInvestmentPolicyStatementGrouping(
                                      context: context,
                                        currentTabIndex: investmentPolicyStatementTabbedCubit.state.currentTabIndex,
                                        shouldClearData: true,
                                        selectedEntity: widget.argument.entityData,
                                        asOnDate: widget.argument.asOnDate,
                                      reportingCurrency: context.read<CurrencyFilterCubit>().state.selectedIPSCurrency,
                                    );
                                  },
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          return Container(
                                            height: ScreenUtil().screenHeight - ScreenUtil().statusBarHeight - kToolbarHeight,
                                            child: orientation == Orientation.landscape && !(constraints.maxWidth > 600 && constraints.maxHeight > 600)
                                                ? Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      FractionallySizedBox(
                                                          alignment: Alignment.centerLeft,
                                                          widthFactor: 0.40,
                                                          child: Stack(
                                                            fit: StackFit.expand,
                                                            children: [
                                                              FractionallySizedBox(
                                                                alignment: Alignment.topCenter,
                                                                heightFactor: 0.20,
                                                                child: FilterWidget(
                                                                  entity: widget.argument.entityData,
                                                                  asOnDate: widget.argument.asOnDate,
                                                                )
                                                              ),
                                                              FractionallySizedBox(
                                                                alignment: Alignment.bottomCenter,
                                                                heightFactor: 0.80,
                                                                child: ItemWidgetList(
                                                                  entity: widget.argument.entityData ?? EntityData(),
                                                                  asOnDate: widget.argument.asOnDate ?? '--',
                                                                  isLandscape: orientation == Orientation.landscape,
                                                                )
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                       const FractionallySizedBox(
                                                        alignment: Alignment.centerRight,
                                                        widthFactor: 0.60,
                                                        child: ChartWidget()
                                                      ),
                                                    ],
                                                  )
                                                : Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                FractionallySizedBox(
                                                  alignment: Alignment.topCenter,
                                                  heightFactor: 0.21,
                                                  child: ItemWidgetList(
                                                    entity: widget.argument.entityData ?? EntityData(),
                                                    asOnDate: widget.argument.asOnDate ?? '--',
                                                  ),
                                                ),
                                                FractionallySizedBox(
                                                    alignment: Alignment.bottomCenter,
                                                    heightFactor: 0.78,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        FractionallySizedBox(
                                                          alignment: Alignment.topCenter,
                                                          heightFactor: 0.10,
                                                          child: FilterWidget(
                                                            entity: widget.argument.entityData,
                                                            asOnDate: widget.argument.asOnDate,
                                                          ),
                                                        ),
                                                        const FractionallySizedBox(
                                                          alignment: Alignment.bottomCenter,
                                                          heightFactor: 0.90,
                                                          child: ChartWidget(),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                    childCount: 1,
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ],
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}
