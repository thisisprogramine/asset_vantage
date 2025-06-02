

import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/clear_cash_balance.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/clear_net_worth.dart';
import 'package:asset_vantage/src/domain/usecases/performance/clear_performance.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/presentation/arguments/login_argument.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/constants/route_constants.dart';
import '../domain/params/no_params.dart';
import '../domain/usecases/income_expense/clear_income_expense.dart';
import '../domain/usecases/investment_policy_statement/clear_investment_policy_statement.dart';
import '../injector.dart';
import 'blocs/authentication/login_check/login_check_cubit.dart';


class AVAppInit extends StatefulWidget {
  const AVAppInit({Key? key}) : super(key: key);
  @override
  State<AVAppInit> createState() => _AVAppInitState();
}

class _AVAppInitState extends State<AVAppInit> {
  late LoginCheckCubit loginCheckCubit;
  late ClearInvestmentPolicyStatement clearInvestmentPolicyStatement;
  late ClearCashBalance clearCashBalance;
  late ClearNetWorth clearNetWorth;
  late ClearPerformance clearPerformance;
  late ClearIncomeExpense clearIncomeExpense;

  @override
  void initState() {
    super.initState();
    loginCheckCubit = getItInstance<LoginCheckCubit>();
    loginCheckCubit.loginCheck();
    clearInvestmentPolicyStatement = getItInstance<ClearInvestmentPolicyStatement>();
    clearCashBalance = getItInstance<ClearCashBalance>();
    clearNetWorth = getItInstance<ClearNetWorth>();
    clearPerformance = getItInstance<ClearPerformance>();
    clearIncomeExpense = getItInstance<ClearIncomeExpense>();
    clearInvestmentPolicyStatement(NoParams());
    clearCashBalance(NoParams());
    clearNetWorth(NoParams());
    clearPerformance(NoParams());
    clearIncomeExpense(NoParams());

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.vulcan,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => loginCheckCubit
            ),
          ],
          child: BlocConsumer<LoginCheckCubit, LoginCheckState>(
            buildWhen: (previous, current) => current is LoginCheckInitial,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_20.h, horizontal: Sizes.dimen_20.w),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(constraints.maxWidth > 600 && constraints.maxHeight > 600)
                              Center(
                                child: SizedBox(
                                  width: ScreenUtil().screenWidth * 0.7,
                                  child: const Logo(
                                    isDark: true,
                                    showBrandLogo: false,
                                  ),
                                ),
                              )
                            else
                              Hero(
                                tag: 'av_pro',
                                child: Logo(
                                  isDark: true,
                                  showBrandLogo: false,
                                  width: ScreenUtil().screenWidth * 0.5,
                                ),
                              ),
                          ],
                        );
                      }
                    );
                  }
                ),
              );
            },
            listenWhen: (previous, current) => current is LoggedIn || current is LoggedOut,
            listener: (context, state) {
              if(state is LoggedIn) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteList.dashboard,
                      (route) => false,
                );
              }else if(state is LoggedOut) {
                getItInstance<GetUserPreference>().call(NoParams()).then((eitherPref) {
                  bool isDark = false;
                  eitherPref.fold((l) {

                  }, (pref) {
                    isDark = pref.darkMode ?? false;
                  });
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteList.login,
                        arguments: LoginArgument(isDark: isDark),
                        (route) => false,
                  );
                });
              }


            },
          ),
        )
    );
  }
}
