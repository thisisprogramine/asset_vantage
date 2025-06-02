
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import '../../blocs/universal_filter/favourite_universal_filter_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class FavouriteUniversalAsOnDateFilter extends StatefulWidget {
  final FavouriteUniversalFilterAsOnDateCubit favouriteUniversalFilterAsOnDateCubit;
  final FavouriteUniversalFilterCubit favouriteUniversalFilterCubit;
  final FavoritesCubit favoritesCubit;

  const FavouriteUniversalAsOnDateFilter({
    super.key, required this.favouriteUniversalFilterAsOnDateCubit,
    required this.favouriteUniversalFilterCubit,
    required this.favoritesCubit,
  });

  @override
  State<FavouriteUniversalAsOnDateFilter> createState() => _FavouriteUniversalAsOnDateFilterState();
}

class _FavouriteUniversalAsOnDateFilterState extends State<FavouriteUniversalAsOnDateFilter> {
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserEntity?>(
        builder: (context, user) {
          return BlocBuilder<FavouriteUniversalFilterAsOnDateCubit,
              FavouriteUniversalFilterAsOnDateState>(
              bloc: widget.favouriteUniversalFilterAsOnDateCubit,
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    _showBottomSheet();
                  },
                  child: Semantics(
                    identifier: "FavDateFilter",
                    container: true,
                    explicitChildNodes: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("${DateFormat(user?.dateFormat ?? 'dd MMM yyyy').format(DateTime.parse(state.asOnDate ?? DateTime.now().toString()))}",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                        UIHelper.horizontalSpaceSmall,
                        SvgPicture.asset("assets/svgs/date_picker.svg", color: AppColor.lightGrey, width: Sizes.dimen_20.w)
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void _showBottomSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Material(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            bloc: widget.favoritesCubit,
            builder: (context, state) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_16.w),
                      child: const FilterNameWithCross(text: StringConstants.dateFilterHeader)
                    ),
                    Expanded(
                        child: CalendarDatePicker(
                          initialDate: DateTime.tryParse(widget.favouriteUniversalFilterAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now(),
                          onDateChanged: (value) {
                            selectedDate = DateFormat('yyyy-MM-dd').format(value);
                            setState(() {});
                          },
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_12.w),
                      child: ApplyButton(
                        text: 'Apply',
                        onPressed: () async{
                          widget.favouriteUniversalFilterAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
                          widget.favouriteUniversalFilterCubit
                              .resetAllTheFavouriteAsOnDate(
                              context: context,
                              reportCubitList:
                              state.reportCubits,
                              isFavorite: true,
                              favorites: state.favorites);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    UIHelper.verticalSpaceSmall
                  ],
                ),
              );
            }
          ),
        );
        return StatefulBuilder(
            builder: (context, setState) {
              return Material(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/back_arrow.svg',
                                  width: Sizes.dimen_24.w,
                                  color: context
                                      .read<AppThemeCubit>()
                                      .state
                                      ?.bottomSheet
                                      ?.backArrowColor !=
                                      null
                                      ? Color(int.parse(context
                                      .read<AppThemeCubit>()
                                      .state!
                                      .bottomSheet!
                                      .backArrowColor!))
                                      : AppColor.primary,
                                ),
                                Text(
                                  'Back',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: context
                                          .read<AppThemeCubit>()
                                          .state
                                          ?.bottomSheet
                                          ?.backArrowColor !=
                                          null
                                          ? Color(int.parse(context
                                          .read<AppThemeCubit>()
                                          .state!
                                          .bottomSheet!
                                          .backArrowColor!))
                                          : AppColor.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'As on Date',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.favouriteUniversalFilterAsOnDateCubit.changeAsOnDate(asOnDate: selectedDate);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Apply',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: context
                                      .read<AppThemeCubit>()
                                      .state
                                      ?.bottomSheet
                                      ?.backArrowColor !=
                                      null
                                      ? Color(int.parse(context
                                      .read<AppThemeCubit>()
                                      .state!
                                      .bottomSheet!
                                      .backArrowColor!))
                                      : AppColor.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CalendarDatePicker(
                      initialDate: DateTime.tryParse(widget.favouriteUniversalFilterAsOnDateCubit.state.asOnDate ?? DateTime.now().subtract(const Duration(days: 1)).toString()) ?? DateTime.now().subtract(const Duration(days: 1)),
                      firstDate: DateTime(1980),
                      lastDate: DateTime.now(),
                      onDateChanged: (value) {
                        selectedDate = DateFormat('yyyy-MM-dd').format(value);
                        setState(() {});
                      },
                    ),
                    if(DateTime.parse((selectedDate ?? DateTime.now().subtract(const Duration(days: 1))).toString())
                        .toIso8601String()
                        .split('T')[0] ==
                        DateTime.now().toIso8601String().split('T')[0])
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: "Note: ",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Securities valuations are likely to be updated from previous market day close.",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              );
            }
        );
      },
    );
  }
}

