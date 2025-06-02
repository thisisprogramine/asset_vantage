import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/favorite_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import '../../blocs/expense/expense_report/expense_report_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/income/income_report/income_report_cubit.dart';
import '../../blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import '../../blocs/performance/performance_report/performance_report_cubit.dart';
import '../../blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import '../../screens/cash_balance_report/cash_balance_filter_modal.dart';
import '../../screens/dashboard/net_worth_summary/net_worth_filter_modal.dart';
import '../../screens/expense_report/expense_universal_filter.dart';
import '../../screens/favorite/favorite_cash_balance_widget.dart';
import '../../screens/favorite/favorite_expense_widget.dart';
import '../../screens/favorite/favorite_income_widget.dart';
import '../../screens/favorite/favorite_net_worth_widget.dart';
import '../../screens/favorite/favorite_performance_widget.dart';
import '../../screens/income_report/income_universal_filter.dart';
import '../../screens/performance_report/performance_universal_filter.dart';
import '../../theme/theme_color.dart';
import 'favorite_sliver_list_item.dart';

class SliverReorderableListWidget extends StatefulWidget {
  final FavoritesLoaded state;
  final UniversalEntityFilterCubit universalEntityFilterCubit;
  final UniversalFilterAsOnDateCubit universalFilterAsOnDateCubit;
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final Function() changeBool;
  final Function() changeBoolFromDetails;
  const SliverReorderableListWidget({
    super.key,
    required this.state,
    required this.changeBool,
    required this.changeBoolFromDetails,
    required this.universalEntityFilterCubit,
    required this.universalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterAsOnDateCubit
  });

  @override
  State<SliverReorderableListWidget> createState() => _SliverReorderableListWidgetState();
}

class _SliverReorderableListWidgetState extends State<SliverReorderableListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      onReorderStart: (p0) {
        HapticFeedback.lightImpact();
        SystemSound.play(SystemSoundType.click);
      },
      onReorder: (oldIndex, newIndex) {
        context.read<FavoritesCubit>().onReorder(
            context: context,
            oldIndex: oldIndex,
            newIndex: newIndex);
      },
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0),
                end: const Offset(0, 0.09),
              ).animate(animation),
              child: RotationTransition(
                turns: Tween<double>(begin: 0, end: 0.01)
                    .animate(animation),
                child: Material(
                  color: Colors.transparent,
                  shadowColor: AppColor.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Sizes.dimen_8.r),
                  ),
                  elevation: 10,
                  child: child,
                ),
              ),
            );
          },
          child: child,
        );
      },
      itemCount: widget.state.favoritesList?.length ?? 0,
      itemBuilder: (context, index) {
        return FavoriteSliverListItem(
          key: Key("${index}"),
          index: index,
          changeBool: widget.changeBool,
          changeBoolFromDetails: widget.changeBoolFromDetails,
          state: widget.state,
          universalEntityFilterCubit: widget.universalEntityFilterCubit,
          universalFilterAsOnDateCubit: widget.universalFilterAsOnDateCubit,
            favouriteUniversalFilterAsOnDateCubit: widget.favouriteUniversalFilterAsOnDateCubit,

        );
      },
    );
  }
}

