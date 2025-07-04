

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';

class NetWorthPeriodFilterList extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final NetWorthPeriodCubit netWorthPeriodCubit;

  const NetWorthPeriodFilterList({
    Key? key,
    required this.onDone,
    required this.scrollController,
    required this.netWorthPeriodCubit,
  }) : super(key: key);

  @override
  State<NetWorthPeriodFilterList> createState() =>
      NetWorthPeriodFilterListState();
}

class NetWorthPeriodFilterListState extends State<NetWorthPeriodFilterList> {
  PeriodItemData? selectedPeriodItemData;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPeriodItemData = widget.netWorthPeriodCubit.state.selectedNetWorthPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
              child: FilterNameWithCross(text: StringConstants.periodFilterString,
              isSubHeader: true,
              onDone: (){
                widget.onDone();
              },)

            ),
            Expanded(
              child: RawScrollbar(
                thickness: Sizes.dimen_2,
                radius: const Radius.circular(Sizes.dimen_10),
                notificationPredicate: (notification) => true,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                thumbColor: AppColor.grey,
                trackColor: AppColor.grey.withValues(alpha: 0.2),
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemBuilder: (context, index) {
                    final item = widget.netWorthPeriodCubit.state.netWorthPeriodList?[index];
                    return GestureDetector(
                      onTap: () {
                        if(item != null) {
                          setState((){
                            selectedPeriodItemData = item;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_0.h,
                            horizontal: Sizes.dimen_14.w),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColor.textGrey
                                        .withOpacity(0.4)))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Sizes.dimen_4.h,
                                    horizontal: Sizes.dimen_14.w),
                                child: Text(item?.name ?? '--',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            if ((item?.id ?? '--') ==
                                (selectedPeriodItemData?.id ?? '--'))
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Sizes.dimen_2.h,
                                    horizontal: Sizes.dimen_14.w),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: context
                                      .read<AppThemeCubit>()
                                      .state
                                      ?.filter
                                      ?.iconColor !=
                                      null
                                      ? Color(int.parse(context
                                      .read<AppThemeCubit>()
                                      .state!
                                      .filter!
                                      .iconColor!))
                                      : AppColor.primary,
                                  size: Sizes.dimen_24.w,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: widget.netWorthPeriodCubit.state.netWorthPeriodList?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.netWorthPeriodCubit.changeSelectedNetWorthPeriod(selectedPeriod: selectedPeriodItemData);
                  widget.onDone();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall
          ],
        ),
      ),
    );
  }
}
