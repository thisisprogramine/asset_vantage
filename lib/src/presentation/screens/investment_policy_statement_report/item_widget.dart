

import 'package:asset_vantage/src/config/app_config.dart';
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/entities/investment_policy_statement/investment_policy_statement_grouping_entity.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/currency_filter/currency_filter_cubit.dart';

class ItemWidget extends StatelessWidget {
  final bool isIpad;
  final int index;
  final String asOnDate;
  final Grouping? grouping;
  final bool isLandscape;
  final EntityData? selectedEntity;

  const ItemWidget({
    Key? key,
    required this.isIpad,
    required this.index,
    required this.asOnDate,
    this.grouping,
    this.isLandscape = false,
    this.selectedEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(grouping?.id == 13) {
          currentTile = ReportTile.ipsAssetClass;
        }else if(grouping?.id == 7) {
          currentTile = ReportTile.ipsAdvisor;
        }else if(grouping?.id == 14) {
          currentTile = ReportTile.ipsCurrency;
        }else if(grouping?.id == 8) {
          currentTile = ReportTile.ipsLiquidity;
        }else if(grouping?.id == 5) {
          currentTile = ReportTile.ipsStrategy;
        }

        context.read<InvestmentPolicyStatementTabbedCubit>().tabChanged(
            context: context,
            currentTabIndex: index, selectedGrouping: grouping, selectedEntity: selectedEntity,
            asOnDate: asOnDate,
            reportingCurrency: context.read<CurrencyFilterCubit>().state.selectedIPSCurrency
        );
      },
      child: BlocBuilder<InvestmentPolicyStatementTabbedCubit, InvestmentPolicyStatementTabbedState>(
          builder: (context, state) {
            if(isLandscape) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: isIpad ? Sizes.dimen_22.w : Sizes.dimen_28.w),
                margin: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      color: state.currentTabIndex == index ? (context.read<AppThemeCubit>().state?.grouping?.borderColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.grouping!.borderColor!)) :  AppColor.primary) : AppColor.grey.withOpacity(0.2),
                      width: state.currentTabIndex == index ? Sizes.dimen_2 : Sizes.dimen_2
                  ),

                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _getImageForGrouping(name: grouping?.name ?? ''),
                      width: Sizes.dimen_24.w,
                      color: context.read<AppThemeCubit>().state?.grouping?.iconClor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.grouping!.iconClor!)) : null,
                    ),
                    UIHelper.horizontalSpace(Sizes.dimen_12.w),
                    Expanded(
                      child: Text(grouping?.name?.replaceAll('-', ' ') ?? '',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: state.currentTabIndex == index ? FontWeight.bold : FontWeight.normal),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              );
            }else {
              return Column(
                children: [
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: isIpad ? Sizes.dimen_22.w : Sizes.dimen_28.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: state.currentTabIndex == index ? (context.read<AppThemeCubit>().state?.grouping?.borderColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.grouping!.borderColor!)) :  AppColor.primary) : AppColor.grey.withOpacity(0.2),
                              width: state.currentTabIndex == index ? Sizes.dimen_2 : Sizes.dimen_2
                          ),

                        ),
                        child: SvgPicture.asset(
                          _getImageForGrouping(name: grouping?.name ?? ''),
                          width: Sizes.dimen_24.w,
                          color: context.read<AppThemeCubit>().state?.grouping?.iconClor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.grouping!.iconClor!)) : null,
                        ),
                      )
                  ),
                  UIHelper.verticalSpace(Sizes.dimen_4.h),
                  Text(grouping?.name?.replaceAll('-', ' ') ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: state.currentTabIndex == index ? FontWeight.bold : FontWeight.normal),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
          }
      ),
    );
  }

  String _getImageForGrouping({required String name}) {
    String image = '';

    switch(name) {
      case 'Advisor':
        image = 'assets/svgs/advisor.svg';
      break;
      case 'Asset-Class':
        image = 'assets/svgs/asset_class.svg';
      break;
      case 'Currency':
        image = 'assets/svgs/currency.svg';
      break;
      case 'Liquidity':
        image = 'assets/svgs/liquidity.svg';
      break;
      case 'Strategy':
        image = 'assets/svgs/strategy.svg';
      break;
      default:
        image = 'assets/svgs/advisor.svg';
      break;
    }

    return image;
  }
}
