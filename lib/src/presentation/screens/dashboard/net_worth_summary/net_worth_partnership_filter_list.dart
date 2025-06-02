import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../config/constants/strings_constants.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/filter_name_with_cross.dart';

class NetWorthPartnershipFilterList extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final NetWorthPartnershipMethodCubit netWorthPartnershipMethodCubit;
  final NetWorthPrimarySubGroupingCubit netWorthPrimarySubGroupingCubit;
  final NetWorthGroupingCubit netWorthGroupingCubit;
  final NetWorthEntityCubit netWorthEntityCubit;
  final NetWorthLoadingCubit netWorthLoadingCubit;
  final NetWorthHoldingMethodCubit netWorthHoldingMethodCubit;
  final String? asOnDate;
  final EntityData? selectedEntity;

  const NetWorthPartnershipFilterList({
    Key? key,
    required this.onDone,
    required this.scrollController,
    required this.netWorthPartnershipMethodCubit,
    required this.netWorthPrimarySubGroupingCubit,
    required this.netWorthGroupingCubit,
    required this.asOnDate,
    required this.netWorthEntityCubit,
    required this.netWorthLoadingCubit,
    required this.netWorthHoldingMethodCubit,
    required this.selectedEntity});

  @override
  State<NetWorthPartnershipFilterList> createState() => _NetWorthPartnershipFilterListState();
}

class _NetWorthPartnershipFilterListState extends State<NetWorthPartnershipFilterList> {
  PartnershipMethodItemData? selectedPartnershipMethod;
  final TextEditingController controller = TextEditingController();
  EntityData? selectedItem;

  @override
  void initState() {
    super.initState();
    //selectedItem = widget.netWorthEntityCubit.state.selectedNetWorthEntity;
    selectedPartnershipMethod = widget.netWorthPartnershipMethodCubit.state.selectedNetWorthPartnershipMethod;
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
                child: FilterNameWithCross(text: StringConstants.partnershipMethod,
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
                child: StatefulBuilder(builder: (context, setState) {
                  return ListView.builder(
                      controller: widget.scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.netWorthPartnershipMethodCubit.state.netWorthPartnershipMethodList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final filterData = widget.netWorthPartnershipMethodCubit.state.netWorthPartnershipMethodList?[index];
                        return GestureDetector(
                          onTap: () {
                            if(filterData != null) {
                              setState((){
                                selectedPartnershipMethod = filterData;
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
                                        color: context
                                            .read<AppThemeCubit>()
                                            .state
                                            ?.bottomSheet
                                            ?.borderColor !=
                                            null
                                            ? Color(int.parse(context
                                            .read<AppThemeCubit>()
                                            .state!
                                            .bottomSheet!
                                            .borderColor!))
                                            : AppColor.grey.withOpacity(0.4)))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Sizes.dimen_4.h,
                                        horizontal: Sizes.dimen_14.w),
                                    child: Text(filterData?.name ?? '--',
                                        style:
                                        Theme.of(context).textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                if (selectedPartnershipMethod?.id == filterData?.id)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Sizes.dimen_2.h,
                                        horizontal: Sizes.dimen_14.w),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: context
                                          .read<AppThemeCubit>()
                                          .state
                                          ?.bottomSheet
                                          ?.checkColor !=
                                          null
                                          ? Color(int.parse(context
                                          .read<AppThemeCubit>()
                                          .state!
                                          .bottomSheet!
                                          .checkColor!))
                                          : AppColor.primary,
                                      size: Sizes.dimen_24.w,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      });
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {

                  widget.netWorthLoadingCubit.startLoading();
                  widget.netWorthPartnershipMethodCubit.changeSelectedNetWorthPartnershipMethod(
                      selectedPartnershipMethod: selectedPartnershipMethod).then((value){
                    widget.netWorthPrimarySubGroupingCubit.loadNetWorthPrimarySubGrouping(
                      context: mounted ?context : null,
                      selectedEntity: widget.selectedEntity,
                      selectedGrouping: widget.netWorthGroupingCubit.state.selectedGrouping,
                      asOnDate: widget.asOnDate,
                      selectedPartnershipMethod: selectedPartnershipMethod,
                      selectedHoldingMethod: widget.netWorthHoldingMethodCubit.state.selectedNetworthHoldingMethod,
                    ).then((value)=> widget.netWorthLoadingCubit.endLoading());
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
