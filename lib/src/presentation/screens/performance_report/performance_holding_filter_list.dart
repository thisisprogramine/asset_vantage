import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/holding_method_entities.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants/size_constants.dart';
import '../../../config/constants/strings_constants.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/performance/performance_entity/performance_entity_cubit.dart';
import '../../blocs/performance/performance_loading/performance_loading_cubit.dart';
import '../../blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import '../../blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import '../../blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/filter_name_with_cross.dart';

class PerformanceHoldingFilterList extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final PerformanceHoldingMethodCubit performanceHoldingMethodCubit;
  final PerformancePrimarySubGroupingCubit performancePrimarySubGroupingCubit;
  final PerformancePrimaryGroupingCubit performancePrimaryGroupingCubit;
  final PerformanceEntityCubit performanceEntityCubit;
  final PerformanceSecondarySubGroupingCubit performanceSecondarySubGroupingCubit;
  final PerformanceSecondaryGroupingCubit performanceSecondaryGroupingCubit;
  final PerformanceLoadingCubit performanceLoadingCubit;
  final PerformancePartnershipMethodCubit performancePartnershipMethodCubit;
  final String? asOnDate;
  final EntityData? selectedEntity;

  const PerformanceHoldingFilterList({
    Key? key,
    required this.onDone,
    required this.scrollController,
    required this.performanceHoldingMethodCubit,
    required this.performancePrimarySubGroupingCubit,
    required this.performancePrimaryGroupingCubit,
    required this.performanceEntityCubit,
    required this.performanceSecondarySubGroupingCubit,
    required this.performanceSecondaryGroupingCubit,
    required this.performanceLoadingCubit,
    required this.asOnDate,
    required this.performancePartnershipMethodCubit,
    required this.selectedEntity});

  @override
  State<PerformanceHoldingFilterList> createState() => _PerformanceHoldingFilterListState();
}

class _PerformanceHoldingFilterListState extends State<PerformanceHoldingFilterList> {
  HoldingMethodItemData? selectedHoldingMethod;
  final TextEditingController controller = TextEditingController();
  EntityData? selectedItem;

  @override
  void initState() {
    super.initState();
    //selectedItem= widget.performanceEntityCubit.state.selectedPerformanceEntity;
    selectedHoldingMethod = widget.performanceHoldingMethodCubit.state.selectedPerformanceHoldingMethod;
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
                child: FilterNameWithCross(text: StringConstants.holdingMethod,
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
                      itemCount: widget.performanceHoldingMethodCubit.state.performanceHoldingList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final filterData = widget.performanceHoldingMethodCubit.state.performanceHoldingList?[index];
                        return GestureDetector(
                          onTap: () {
                            if(filterData != null) {
                              setState((){
                                selectedHoldingMethod = filterData;
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
                                if (selectedHoldingMethod?.id == filterData?.id)
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
                  widget.performanceLoadingCubit.startLoading();
                  widget.performanceHoldingMethodCubit.changeSelectedPerformanceHoldingMethod(
                      selectedHoldingMethod: selectedHoldingMethod).then((value){
                    Future.wait([
                      widget.performancePrimarySubGroupingCubit.loadPerformancePrimarySubGrouping(
                        context: context,
                        selectedEntity: widget.selectedEntity,
                        selectedGrouping: widget.performancePrimaryGroupingCubit.state.selectedGrouping,
                        asOnDate: widget.asOnDate,
                        selectedPartnershipMethod: widget.performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
                        selectedHoldingMethod: selectedHoldingMethod
                      ),
                      widget.performanceSecondarySubGroupingCubit.loadPerformanceSecondarySubGrouping(
                          context: context,
                          primarySubGroupingItem: widget.performancePrimarySubGroupingCubit.state.selectedSubGroupingList,
                          selectedEntity: widget.selectedEntity,
                          selectedGrouping: widget.performanceSecondaryGroupingCubit.state.selectedGrouping,
                          asOnDate: widget.asOnDate,
                          selectedPartnershipMethod: widget.performancePartnershipMethodCubit.state.selectedPerformancePartnershipMethod,
                        selectedHoldingMethod: selectedHoldingMethod
                      )
                    ]).then((value)=> widget.performanceLoadingCubit.endLoading());
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
