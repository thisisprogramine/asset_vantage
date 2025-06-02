
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/screens/income_report/income_denomination_filter.dart';
import 'package:asset_vantage/src/presentation/widgets/filter_name_with_cross.dart';
import 'package:asset_vantage/src/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/currency/currency_entity.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/income/income_currency/income_currency_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class IncomeCurrencyFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final IncomeCurrencyCubit incomeCurrencyCubit;
  final IncomeDenominationCubit incomeDenominationCubit;
  const IncomeCurrencyFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.incomeCurrencyCubit,
    required this.incomeDenominationCubit,
  });

  @override
  State<IncomeCurrencyFilter> createState() => _IncomeCurrencyFilterState();
}

class _IncomeCurrencyFilterState extends State<IncomeCurrencyFilter> {
  Currency? selectedCurrency;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.incomeCurrencyCubit.state.selectedIncomeCurrency;
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
                  text: StringConstants.currencyFilterString,
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
                },),
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
                  itemCount: widget.incomeCurrencyCubit.state.incomeCurrencyList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.incomeCurrencyCubit.state.incomeCurrencyList?[index];
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
                  widget.incomeCurrencyCubit.changeSelectedIncomeCurrency(selectedCurrency: selectedCurrency, incomeDenominationCubit: widget.incomeDenominationCubit);
                  widget.onDone();
                },
              ),
            ),
            UIHelper.verticalSpaceSmall
          ],
        ),
      ),
    );
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onDone();
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_6.w),
                        child: SvgPicture.asset("assets/svgs/filter_back_arrow.svg", )
                    ),
                  ),
                  UIHelper.horizontalSpaceSmall,
                  Expanded(child: Text("Currency", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CrossSign(),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                    margin: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColor.grey.withValues(alpha: 0.5), width: Sizes.dimen_1),
                      borderRadius: BorderRadius.circular(Sizes.dimen_8),
                    ),
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
                            child: SvgPicture.asset(
                                'assets/svgs/search_icon.svg',
                                width: Sizes.dimen_14.w,
                                color: AppColor.grey.withValues(alpha: 0.5))),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_2.h,
                            horizontal: Sizes.dimen_12.w),
                        isDense: true,
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.grey.withValues(alpha: 0.5)),
                        prefixIconConstraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ),
              ],
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
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.incomeCurrencyCubit.state.incomeCurrencyList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.incomeCurrencyCubit.state.incomeCurrencyList?[index];
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
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
              child: ApplyButton(
                text: 'Apply',
                onPressed: () {
                  widget.incomeCurrencyCubit.changeSelectedIncomeCurrency(selectedCurrency: selectedCurrency, incomeDenominationCubit: widget.incomeDenominationCubit);
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
                  widget.incomeCurrencyCubit.changeSelectedIncomeCurrency(selectedCurrency: selectedCurrency, incomeDenominationCubit: widget.incomeDenominationCubit);
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
                    if((widget.incomeCurrencyCubit.state.incomeCurrencyList?.any((element) =>
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
                          itemCount: widget.incomeCurrencyCubit.state.incomeCurrencyList?.length ?? 0,
                          itemBuilder: (context, index) {
                            final filterData = widget.incomeCurrencyCubit.state.incomeCurrencyList?[index];
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
