

import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/constants/size_constants.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../utilities/helper/ui_helper.dart';
import '../../../blocs/app_theme/theme_cubit.dart';
import '../../../theme/theme_color.dart';
import '../../../widgets/apply_button.dart';
import '../../../widgets/crossSign.dart';

class NetWorthCurrencyFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final NetWorthCurrencyCubit netWorthCurrencyCubit;
  final NetWorthDenominationCubit netWorthDenominationCubit;
  const NetWorthCurrencyFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.netWorthCurrencyCubit,
    required this.netWorthDenominationCubit,
  });

  @override
  State<NetWorthCurrencyFilter> createState() => _NetWorthCurrencyFilterState();
}

class _NetWorthCurrencyFilterState extends State<NetWorthCurrencyFilter> {
  Currency? selectedCurrency;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.netWorthCurrencyCubit.state.selectedNetWorthCurrency;
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
              child: FilterNameWithCross(text: StringConstants.currencyFilterString,
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
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.netWorthCurrencyCubit.state.netWorthCurrencyList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.netWorthCurrencyCubit.state.netWorthCurrencyList?[index];
                    if((filterData?.code
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                        true) ||
                        controller.text.isEmpty) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if(filterData != null) {
                                setState((){
                                  selectedCurrency = filterData;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: context.read<AppThemeCubit>().state?.bottomSheet?.borderColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.borderColor!)) : AppColor.grey.withOpacity(0.4))
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_14.w),
                                      child: Text(
                                          filterData?.code ?? '--',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                  if(selectedCurrency?.id == filterData?.id)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_14.w),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: context.read<AppThemeCubit>().state?.bottomSheet?.checkColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.checkColor!)) : AppColor.primary,
                                        size: Sizes.dimen_24.w,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }else {
                      return const SizedBox.shrink();
                    }

                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
              child: ApplyButton(
                text: StringConstants.applyButton,
                onPressed: () {
                  widget.netWorthCurrencyCubit.changeSelectedNetWorthCurrency(selectedCurrency: selectedCurrency, netWorthDenominationCubit: widget.netWorthDenominationCubit);
                  widget.onDone();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall
          ],
        ),
      ),
    );
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_14.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.onDone,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svgs/back_arrow.svg', width: Sizes.dimen_24.w, color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary,),
                    Text('Back',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text('Currency',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GestureDetector(
                onTap: () {
                  widget.netWorthCurrencyCubit.changeSelectedNetWorthCurrency(selectedCurrency: selectedCurrency, netWorthDenominationCubit: widget.netWorthDenominationCubit);
                  widget.onDone();
                },
                child: Text('Apply',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.read<AppThemeCubit>().state?.bottomSheet?.backArrowColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.backArrowColor!)) : AppColor.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_12.w),
                            child: Card(
                              color: AppColor.white.withOpacity(0.8),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              child: TextFormField(
                                key: widget.key,
                                controller: controller,
                                textInputAction: TextInputAction.search,
                                onChanged: (String text) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_2.h,
                                          horizontal: Sizes.dimen_12.w),
                                      child: SvgPicture.asset('assets/svgs/search.svg',
                                          width: Sizes.dimen_24.w,
                                          color: Theme.of(context).iconTheme.color)),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_2.h,
                                      horizontal: Sizes.dimen_12.w),
                                  isDense: true,
                                  border: InputBorder.none,
                                  prefixIconConstraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.text = "";
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: Sizes.dimen_12.w),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColor.textGrey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    if((widget.netWorthCurrencyCubit.state.netWorthCurrencyList?.any((element) =>
                    (element?.code
                        ?.toLowerCase()
                        .contains(controller.text.toLowerCase()) ??
                        true) ||
                        controller.text.isEmpty) ??
                        false))
                      Expanded(
                        child: ListView.builder(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.netWorthCurrencyCubit.state.netWorthCurrencyList?.length ?? 0,
                          itemBuilder: (context, index) {
                            final filterData = widget.netWorthCurrencyCubit.state.netWorthCurrencyList?[index];
                            if((filterData?.code
                                ?.toLowerCase()
                                .contains(controller.text.toLowerCase()) ??
                                true) ||
                                controller.text.isEmpty) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if(filterData != null) {
                                        setState((){
                                          selectedCurrency = filterData;
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(color: context.read<AppThemeCubit>().state?.bottomSheet?.borderColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.borderColor!)) : AppColor.grey.withOpacity(0.4))
                                          )
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_14.w),
                                              child: Text(
                                                  filterData?.code ?? '--',
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                          ),
                                          if(selectedCurrency?.id == filterData?.id)
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_14.w),
                                              child: Icon(
                                                Icons.check_rounded,
                                                color: context.read<AppThemeCubit>().state?.bottomSheet?.checkColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.bottomSheet!.checkColor!)) : AppColor.primary,
                                                size: Sizes.dimen_24.w,
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }else {
                              return const SizedBox.shrink();
                            }

                          },
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Text(
                            'No result found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                  ],
                );
              }
          ),
        )
      ],
    );
  }
}
