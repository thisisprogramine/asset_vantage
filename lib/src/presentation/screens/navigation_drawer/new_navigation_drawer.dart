import 'dart:developer';

import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/domain/entities/authentication/user_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/user/user_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_chart/expense_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_chart/income_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_currency/performance_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_entity/performance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_period/performance_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_report/performance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:carousel_slider/carousel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/route_constants.dart';
import '../../../data/models/preferences/user_preference.dart';
import '../../../data/models/return_percentage/return_percentage_model.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../domain/usecases/preferences/save_user_preference.dart';
import '../../../injector.dart';
import '../../arguments/cash_balance_argument.dart';
import '../../arguments/document_argument.dart';
import '../../arguments/expense_report_argument.dart';
import '../../arguments/income_report_argument.dart';
import '../../arguments/performance_argument.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/dashboard_filter/dashboard_filter_cubit.dart';
import '../../blocs/income/income_report/income_report_cubit.dart';
import '../../blocs/stealth/stealth_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../widgets/user_guide_widget.dart';
import 'new_drawer_item.dart';

class NewNavigationDrawer extends StatefulWidget {
  final PerformanceReportCubit performanceReportCubit;
  final CashBalanceReportCubit cashBalanceReportCubit;
  final IncomeReportCubit incomeReportCubit;
  final ExpenseReportCubit expenseReportCubit;
  final IncomeChartCubit incomeChartCubit;
  final ExpenseChartCubit expenseChartCubit;
  final CashBalanceSortCubit cashBalanceSortCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final VoidCallback onNetWorthTap;
  final VoidCallback onHomeTap;
   const NewNavigationDrawer({
     super.key,
     required this.universalFilterAsOnDateCubit,
     required this.universalEntityFilterCubit,
     required this.favouriteUniversalFilterAsOnDateCubit,
     required this.performanceReportCubit,
     required this.incomeReportCubit,
     required this.expenseReportCubit,
     required this.incomeChartCubit,
     required this.expenseChartCubit,
     required this.cashBalanceReportCubit,
     required this.cashBalanceSortCubit,
     required this.onNetWorthTap,
     required this.onHomeTap,});

  @override
  State<NewNavigationDrawer> createState() => _NewNavigationDrawerState();
}

class _NewNavigationDrawerState extends State<NewNavigationDrawer> {
  bool defaultTheme = true;
  UserPreference? userPreference;
  late GetUserPreference getUserPreference;
  late SaveUserPreference saveUserPreference;

  @override
  void initState() {
    getUserPreference = getItInstance<GetUserPreference>();
    saveUserPreference = getItInstance<SaveUserPreference>();
    getUserPreference(NoParams()).then((value) {
      value.fold((l) {
        debugPrint(l.toString());
      }, (r) {
        setState(() {

          defaultTheme = r.defaultTheme ?? false;
          userPreference = r;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: ScreenUtil().screenWidth * 0.65,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: Sizes.dimen_18),
                  child: Semantics(
                    identifier: "menu back arrow",
                    child: SvgPicture.asset('assets/svgs/back_arrow.svg',width: Sizes.dimen_24,
                      color: AppColor.textGrey,),
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h,horizontal: Sizes.dimen_5),
              margin: EdgeInsets.only(left: Sizes.dimen_28,right: Sizes.dimen_28,top: Sizes.dimen_28),
              width: double.infinity,

              decoration: BoxDecoration(
                color: AppColor.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Sizes.dimen_12)
              ),
              child: BlocBuilder<UserCubit,UserEntity?>(
                builder: (context, user) {
                  if(user?.username != null){
                    return Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                          identifier : "navigation_username",
                            label: "userName",
                            container: true,
                            explicitChildNodes: true,
                            child: Text(user?.displayname ?? '--',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: Sizes.dimen_17.sp, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Semantics(
                            identifier: "navigation_systemname",
                            label: "systemName",
                            container: true,
                            explicitChildNodes: true,
                            child: Text(userPreference?.systemName ?? '--',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Sizes.dimen_14, fontWeight: FontWeight.w600, color: AppColor.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  else{
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                      child: Card(
                        child: Shimmer.fromColors(
                          baseColor: AppColor.white.withOpacity(0.1),
                          highlightColor: AppColor.white.withOpacity(0.2),
                          direction: ShimmerDirection.ltr,
                          period: const Duration(seconds: 1),
                          child: Container(
                            height: Sizes.dimen_14.h,
                            decoration: BoxDecoration(
                              color: AppColor.grey,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppColor.grey.withValues(alpha: 0.5),
                    height: 0.5,
                    margin: EdgeInsets.symmetric(
                        vertical: Sizes.dimen_8.h,
                      horizontal: Sizes.dimen_26.w
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                physics:  BouncingScrollPhysics(),
                children: [
                  Semantics(
                    identifier: "Home_field",
                    child: NewDrawerItem(
                      icon_img: 'assets/svgs/home_icon.svg',
                      title: 'Home',
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onHomeTap();
                      },

                    ),
                  ),
                  Semantics(
                    identifier: "NetWorth_field",
                    child: NewDrawerItem(
                      icon_img: 'assets/svgs/networth_icon.svg',
                      title: 'Net Worth',
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onNetWorthTap();
                      },

                    ),
                  ),
                  Semantics(
                    identifier: "Performance_field",
                    child: NewDrawerItem(
                      icon_img: 'assets/svgs/performance_icon.svg',
                      title: 'Performance',
                      onPressed: () {
                        CarouselTracker.wasCollapsed = true;
                        CarouselTracker.isPerformance=true;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(RouteList.performanceReport,arguments: PerformanceArgument(
                            performanceSortCubit: widget.performanceReportCubit.performanceSortCubit,
                            performanceEntityCubit: widget.performanceReportCubit.performanceEntityCubit,
                            universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                            universalEntityFilterCubit: widget.universalEntityFilterCubit,
                            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                            performanceReportCubit: widget.performanceReportCubit,
                            performancePrimaryGroupingCubit: widget.performanceReportCubit.performancePrimaryGroupingCubit,
                            performanceSecondaryGroupingCubit: widget.performanceReportCubit.performanceSecondaryGroupingCubit,
                            performancePrimarySubGroupingCubit: widget.performanceReportCubit.performancePrimarySubGroupingCubit,
                            performanceSecondarySubGroupingCubit: widget.performanceReportCubit.performanceSecondarySubGroupingCubit,
                            performanceNumberOfPeriodCubit: widget.performanceReportCubit.performanceNumberOfPeriodCubit,
                            performanceReturnPercentCubit: widget.performanceReportCubit.performanceReturnPercentCubit,
                            performanceCurrencyCubit: widget.performanceReportCubit.performanceCurrencyCubit,
                            performanceDenominationCubit: widget.performanceReportCubit.performanceDenominationCubit,
                            performancePeriodCubit: widget.performanceReportCubit.performancePeriodCubit,
                            performanceAsOnDateCubit: widget.performanceReportCubit.performanceAsOnDateCubit,
                            performanceLoadingCubit: widget.performanceReportCubit.performanceLoadingCubit,
                            returnType: widget.performanceReportCubit.performanceReturnPercentCubit.state.selectedPerformanceReturnPercentList?.last?.value ?? ReturnType.FYTD,
                            entityData: context.read<DashboardFilterCubit>().state.selectedFilter,
                            asOnDate: "30 July 2024", performancePartnershipMethodCubit: widget.performanceReportCubit.performancePartnershipMethodCubit,
                            performanceHoldingMethodCubit: widget.performanceReportCubit.performanceHoldingMethodCubit)
                        );
                      },

                    ),
                  ),
                  Semantics(
                    identifier: "CashBalance_field",
                    child: NewDrawerItem(
                      icon_img: 'assets/svgs/cashbalance_icon.svg',
                      title: 'Cash Balance',
                      onPressed: () {
                        CarouselTracker.wasCollapsed = true;
                        CarouselTracker.isCashBalance=true;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                          RouteList.cashBalanceReport,
                          arguments: CashBalanceArgument(
                            cashBalanceLoadingCubit: widget.cashBalanceReportCubit.cashBalanceLoadingCubit,
                            cashBalanceEntityCubit: widget.cashBalanceReportCubit.cashBalanceEntityCubit,
                            universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                            universalEntityFilterCubit: widget.universalEntityFilterCubit,
                            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                            cashBalancePrimaryGroupingCubit: widget.cashBalanceReportCubit.cashBalancePrimaryGroupingCubit,
                            cashBalancePrimarySubGroupingCubit: widget.cashBalanceReportCubit.cashBalancePrimarySubGroupingCubit,
                            cashBalanceAsOnDateCubit: widget.cashBalanceReportCubit.cashBalanceAsOnDateCubit,
                            cashBalanceCurrencyCubit:widget.cashBalanceReportCubit.cashBalanceCurrencyCubit,
                            cashBalanceDenominationCubit: widget.cashBalanceReportCubit.cashBalanceDenominationCubit,
                            cashBalanceNumberOfPeriodCubit: widget.cashBalanceReportCubit.cashBalanceNumberOfPeriodCubit,
                            cashBalancePeriodCubit: widget.cashBalanceReportCubit.cashBalancePeriodCubit,
                            cashBalanceReportCubit: widget.cashBalanceReportCubit,
                            cashBalanceAccountCubit: widget.cashBalanceReportCubit.cashBalanceAccountCubit,
                            cashBalanceSortCubit: widget.cashBalanceSortCubit,

                          ),
                        );
                      },

                    ),
                  ),
                  Semantics(
                    identifier: "Income_field",
                    child: NewDrawerItem(
                      icon_img: 'assets/svgs/income_icon.svg',
                      title: 'Income',
                      onPressed: () {
                        CarouselTracker.wasCollapsed = true;
                        CarouselTracker.isIncome=true;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(RouteList.incomeReportScreen,
                            arguments: IncomeReportArgument(
                              incomeLoadingCubit: widget.incomeReportCubit.incomeLoadingCubit,
                              incomeReportCubit: widget.incomeReportCubit,
                              incomeSortCubit: widget.incomeReportCubit.incomeSortCubit,
                              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                              universalEntityFilterCubit: widget.universalEntityFilterCubit,
                              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                              incomeEntityCubit: widget.incomeReportCubit.incomeEntityCubit,
                              incomeAccountCubit: widget.incomeReportCubit.incomeAccountCubit,
                              incomePeriodCubit: widget.incomeReportCubit.incomePeriodCubit,
                              incomeNumberOfPeriodCubit: widget.incomeReportCubit.incomeNumberOfPeriodCubit,
                              incomeChartCubit:widget.incomeChartCubit,
                              incomeCurrencyCubit: widget.incomeReportCubit.incomeCurrencyCubit,
                              incomeDenominationCubit: widget.incomeReportCubit.incomeDenominationCubit,
                              incomeAsOnDateCubit: widget.incomeReportCubit.incomeAsOnDateCubit,
                            ));
                      },

                    ),
                  ),
                  Semantics(
                    identifier: "Expense_field",
                    child: NewDrawerItem(
                      icon_img: 'assets/svgs/expense_icon.svg',
                      title: 'Expense',
                      onPressed: () {
                        CarouselTracker.wasCollapsed = true;
                        CarouselTracker.isExpense=true;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(RouteList.expenseReportScreen,
                            arguments: ExpenseReportArgument(
                              expenseLoadingCubit: widget.expenseReportCubit.expenseLoadingCubit,
                              expenseReportCubit: widget.expenseReportCubit,
                              expenseSortCubit: widget.expenseReportCubit.expenseSortCubit,
                              expenseEntityCubit: widget.expenseReportCubit.expenseEntityCubit,
                              expenseAccountCubit: widget.expenseReportCubit.expenseAccountCubit,
                              expensePeriodCubit: widget.expenseReportCubit.expensePeriodCubit,
                              expenseNumberOfPeriodCubit: widget.expenseReportCubit.expenseNumberOfPeriodCubit,
                              expenseChartCubit: widget.expenseChartCubit,
                              expenseCurrencyCubit: widget.expenseReportCubit.expenseCurrencyCubit,
                              universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
                              universalEntityFilterCubit: widget.universalEntityFilterCubit,
                              favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,
                              expenseDenominationCubit: widget.expenseReportCubit.expenseDenominationCubit,
                              expenseAsOnDateCubit: widget.expenseReportCubit.expenseAsOnDateCubit,
                            ));
                      },

                    ),
                  ),
                  NewDrawerItem(
                    key: const Key("Documents_field"),
                    icon_img: 'assets/svgs/document_vault.svg',
                    title: 'Documents',
                    onPressed: () {
                      //CarouselTracker.wasCollapsed = true;
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(RouteList.documents,
                          arguments: DocumentArgument(
                              dashboardFilterCubit: context.read<DashboardFilterCubit>()));
                    },

                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 0.4,
                    color: AppColor.grey.withValues(alpha: 0.6)
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/pngs/av_pro.png',width: Sizes.dimen_80.w,height: Sizes.dimen_32.h,),
                InkWell(
                  onTap: (){
                    context.read<FavoritesCubit>().cFavourite();
                      try {
                        BlocProvider.of<LoginCubit>(context).logout().then((value) {
                          BlocProvider.of<StealthCubit>(context).hide();
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                          BlocProvider.of<StealthCubit>(context).hide();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteList.initial,
                                (route) => false,
                          );
                        });

                      }catch(e) {
                        print('ERROR: $e');
                      }
                  },

                  child: Row(
                    children: [
                      Text(StringConstants.logout,style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize:Sizes.dimen_16.sp,fontWeight: FontWeight.w600),),
                      SizedBox(width: Sizes.dimen_8.w,),
                      Icon(Icons.logout,color: AppColor.textGrey,size: Sizes.dimen_24,)
                    ],
                  ),
                )

              ],
            )




          ],
        ),
      ),
    );
  }


}
