import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/login_check/login_check_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/currency_filter/currency_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/denomination_filter/denomination_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/stealth/stealth_cubit.dart';
import 'package:asset_vantage/src/presentation/routes/routes.dart';
import 'package:asset_vantage/src/presentation/screens/loading/loading_screen.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:overlay_support/overlay_support.dart';
import '../config/constants/route_constants.dart';
import '../injector.dart';
import '../utilities/helper/flash_helper.dart';
import 'blocs/app_theme/theme_cubit.dart';
import 'blocs/authentication/login/login_cubit.dart';
import 'blocs/authentication/mfa_login/mfa_login_cubit.dart';
import 'blocs/authentication/token/token_cubit.dart';
import 'blocs/authentication/user/user_cubit.dart';
import 'blocs/dashboard_filter/dashboard_filter_cubit.dart';
import 'blocs/favorites/favorites_cubit.dart';
import 'blocs/internet_connectivity/internet_connectivity_cubit.dart';
import 'blocs/loading/loading_cubit.dart';
import 'blocs/timer/countdown_timer_cubit.dart';
import 'blocs/user_guide_assets/user_guide_assets_cubit.dart';
import 'routes/custom_navigation_observer.dart';
import 'theme/app_theme.dart';

class AssetVantageApp extends StatefulWidget {
  const AssetVantageApp({super.key});

  @override
  _AssetVantageAppState createState() => _AssetVantageAppState();
}

class _AssetVantageAppState extends State<AssetVantageApp>
    with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late LoginCubit _loginCubit;
  late UserGuideAssetsCubit userGuideAssetsCubit;
  late FavoritesCubit _favoritesCubit;
  late LoadingCubit _loadingCubit;
  late UserCubit _userCubit;
  late TokenCubit tokenCubit;
  late AppThemeCubit _appThemeCubit;
  late MfaLoginCubit _mfaLoginCubit;
  late TimerCubit timerCubit;
  late LoginCubit loginCubit;
  late DenominationFilterCubit denominationFilterCubit;
  late CurrencyFilterCubit currencyFilterCubit;
  late InternetConnectivityCubit _internetConnectivityCubit;
  late StealthCubit _stealthCubit;
  late DashboardFilterCubit dashboardFilterCubit;
  bool _inactive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    dashboardFilterCubit = getItInstance<DashboardFilterCubit>();
    userGuideAssetsCubit = getItInstance<UserGuideAssetsCubit>();
    userGuideAssetsCubit.loadUserGuideAssets();
    _loginCubit = getItInstance<LoginCubit>();
    _loadingCubit = getItInstance<LoadingCubit>();
    _stealthCubit = getItInstance<StealthCubit>();
    _internetConnectivityCubit = getItInstance<InternetConnectivityCubit>();
    _userCubit = getItInstance<UserCubit>();
    tokenCubit = _userCubit.tokenCubit;
    _favoritesCubit = _userCubit.favoritesCubit;
    _appThemeCubit = _userCubit.appThemeCubit;
    _mfaLoginCubit = getItInstance<MfaLoginCubit>();
    timerCubit = getItInstance<TimerCubit>();
    loginCubit = getItInstance<LoginCubit>();
    denominationFilterCubit = getItInstance<DenominationFilterCubit>();
    currencyFilterCubit = getItInstance<CurrencyFilterCubit>();
    _internetConnectivityCubit.establishInternetConnectivityStream();
  }

  @override
  void dispose() {
    _loginCubit.close();
    userGuideAssetsCubit.close();
    _favoritesCubit.close();
    _loadingCubit.close();
    _stealthCubit.close();
    _userCubit.close();
    tokenCubit.close();
    _appThemeCubit.close();
    _mfaLoginCubit.close();
    timerCubit.close();
    loginCubit.close();
    denominationFilterCubit.close();
    currencyFilterCubit.close();
    _internetConnectivityCubit.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _inactive = state == AppLifecycleState.inactive;
    getItInstance<GetUserPreference>().call(NoParams()).then((preference) {
      preference.fold((l) {}, (user) {
        if(user.loginStatus ?? false) {
          if(state == AppLifecycleState.resumed && JwtDecoder.isExpired(user.idToken ?? '') || user.idToken == null) {
            try{
              AppHelpers.logout(context: _navigatorKey.currentContext!);
            }catch(e) {
              print("ERROR:: $e");
            }
            print("Logout Finished");
          }
        }
      });
    });


    setState(() {});
  }

  void navigateBack() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteList.performanceReport,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>.value(value: _loginCubit),
        BlocProvider<UserGuideAssetsCubit>.value(value: userGuideAssetsCubit),
        BlocProvider<FavoritesCubit>.value(value: _favoritesCubit),
        BlocProvider<LoadingCubit>.value(value: _loadingCubit),
        BlocProvider<StealthCubit>.value(value: _stealthCubit),
        BlocProvider<DashboardFilterCubit>.value(value: dashboardFilterCubit),
        BlocProvider<InternetConnectivityCubit>.value(
            value: _internetConnectivityCubit),
        BlocProvider<UserCubit>.value(value: _userCubit),
        BlocProvider<TokenCubit>.value(value: tokenCubit),
        BlocProvider<AppThemeCubit>.value(value: _appThemeCubit),
        BlocProvider<TimerCubit>.value(value: timerCubit),
        BlocProvider<MfaLoginCubit>.value(value: _mfaLoginCubit),
        BlocProvider<LoginCubit>.value(value: loginCubit),
        BlocProvider<DenominationFilterCubit>.value(
            value: denominationFilterCubit),
        BlocProvider<CurrencyFilterCubit>.value(value: currencyFilterCubit),
      ],
      child: OrientationBuilder(builder: (context, orientation) {
        return ScreenUtilInit(
            designSize: orientation == Orientation.landscape
                ? const Size(896, 270)
                : const Size(414, 360),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, ctx) {
              return LayoutBuilder(builder: (context, constraints) {
                return BlocBuilder<AppThemeCubit, AppThemeModel?>(
                    builder: (context, theme) {
                  return BlocBuilder<StealthCubit, bool>(
                      builder: (context, stealthState) {
                    return BlocBuilder<DenominationFilterCubit,
                            DenominationFilterState>(
                        builder: (context, denomination) {
                      return BlocBuilder<CurrencyFilterCubit,
                          CurrencyFilterState>(builder: (context, currency) {
                        return OverlaySupport.global(
                          child: GetMaterialApp(
                            navigatorKey: _navigatorKey,
                            debugShowCheckedModeBanner: false,
                            title: StringConstants.assetVantageApp,
                            theme: AppTheme.getAppDarkTheme(
                                context: context,
                                isIpad: (constraints.maxWidth > 600 &&
                                    constraints.maxHeight > 600)),
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                                child: Stack(
                                  children: [
                                    LoadingScreen(
                                      screen: child!,
                                      back: navigateBack,
                                    ),
                                    if (_inactive)
                                      Positioned.fill(
                                          child: Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/pngs/av_pro.png",
                                            width: ScreenUtil().screenWidth * 0.5,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Text(
                                              "AV Pro",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                      fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                  ],
                                ),
                              );
                            },
                            navigatorObservers: [CustomNavigationObserver()],
                            initialRoute: RouteList.initial,
                            onGenerateRoute: (RouteSettings settings) {
                              final routes = Routes.getRoutes(settings);
                              final WidgetBuilder? builder =
                                  routes[settings.name];
                              return MaterialPageRoute(
                                builder: builder!,
                                settings: settings,
                              );
                            },
                          ),
                        );
                      });
                    });
                  });
                });
              });
            });
      }),
    );
  }
}
