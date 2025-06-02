

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/dashboard/dashboard_list_entity.dart';
import '../../../../domain/entities/net_worth/net_worth_grouping_entity.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';

class NetWorthGroupingFilterList extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final NetWorthGroupingCubit netWorthGroupingCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthLoadingCubit netWorthLoadingCubit;
  final String? asOnDate;
  final EntityData? selectedEntity;

  const NetWorthGroupingFilterList({
    Key? key,
    required this.onDone,
    required this.scrollController,
    required this.netWorthEntityCubit,
    required this.netWorthLoadingCubit,
    required this.netWorthPrimarySubGroupingCubit,
    required this.asOnDate,
    required this.netWorthGroupingCubit,
    required this.selectedEntity,
  }) : super(key: key);

  @override
  State<NetWorthGroupingFilterList> createState() => NetWorthGroupingFilterListState();
}

class NetWorthGroupingFilterListState extends State<NetWorthGroupingFilterList> {
  final TextEditingController controller = TextEditingController();
  GroupingEntity? selectedPrimaryGrouping;


  @override
  void initState() {
    super.initState();
    selectedPrimaryGrouping = widget.netWorthGroupingCubit.state.selectedGrouping;
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
              child: FilterNameWithCross(
                  text: StringConstants.primaryGrpFilterString,
              isSubHeader: true,
              onDone: (){
                widget.onDone();
              },)

            ),

            SearchBarWidget(
                textController: controller,
                feildKey: widget.key,
                onChanged: (String text) {
              setState(() {});
            }),
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
                    final item = widget.netWorthGroupingCubit.state.groupingList?[index];
                    if ((item?.name
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                        true) ||
                        controller.text.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          if(item != null) {
                            setState((){
                              selectedPrimaryGrouping = item;
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
                                      color: AppColor.grey.withValues(alpha: 0.5)))),
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
                                  (selectedPrimaryGrouping?.id ?? ''))
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
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: widget.netWorthGroupingCubit.state.groupingList?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.netWorthLoadingCubit.startLoading();
                  widget.netWorthGroupingCubit.changeSelectedNetWorthPrimaryGrouping(
                    selectedGrouping: selectedPrimaryGrouping,
                  ).then((value) {
                    widget.netWorthPrimarySubGroupingCubit.loadNetWorthPrimarySubGrouping(
                        context: mounted ? context : null,
                        selectedEntity: widget.selectedEntity,
                        selectedGrouping: widget.netWorthGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate
                    ).then((value) => widget.netWorthLoadingCubit.endLoading());
                  });
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
