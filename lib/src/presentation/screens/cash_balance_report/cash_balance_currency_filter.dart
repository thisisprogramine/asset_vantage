
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
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
import '../../blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import '../../blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/apply_button.dart';
import '../../widgets/crossSign.dart';

class CashBalanceCurrencyFilter extends StatefulWidget {
  final void Function() onDone;
  final ScrollController scrollController;
  final CashBalanceCurrencyCubit cashBalanceCurrencyCubit;
  final CashBalanceDenominationCubit cashBalanceDenominationCubit;
  const CashBalanceCurrencyFilter({
    super.key,
    required this.onDone,
    required this.scrollController,
    required this.cashBalanceCurrencyCubit,
    required this.cashBalanceDenominationCubit,
  });

  @override
  State<CashBalanceCurrencyFilter> createState() => _CashBalanceCurrencyFilterState();
}

class _CashBalanceCurrencyFilterState extends State<CashBalanceCurrencyFilter> {
  Currency? selectedCurrency;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.cashBalanceCurrencyCubit.state.selectedCashBalanceCurrency;
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
                  itemCount: widget.cashBalanceCurrencyCubit.state.cashBalanceCurrencyList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final filterData = widget.cashBalanceCurrencyCubit.state.cashBalanceCurrencyList?[index];
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
                  widget.cashBalanceCurrencyCubit.changeSelectedCashBalanceCurrency(selectedCurrency: selectedCurrency, cashBalanceDenominationCubit: widget.cashBalanceDenominationCubit);
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
