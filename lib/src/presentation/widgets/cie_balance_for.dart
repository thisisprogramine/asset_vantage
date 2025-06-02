import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';

class BalanceFor extends StatefulWidget {
  final bool isSummary;
  final String balanceFor;
  final String balance;
  const BalanceFor({
    super.key,
    required this.isSummary,
    required this.balanceFor,
    required this.balance,
  });

  @override
  State<BalanceFor> createState() => _BalanceForState();
}

class _BalanceForState extends State<BalanceFor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: !widget.isSummary ? Sizes.dimen_2.h : Sizes.dimen_6.h),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.balanceFor}",
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(
              color: AppColor.grey,
              fontWeight:
              FontWeight.bold,
            ),
          ),
          Text(
            widget.balance,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                color: AppColor
                    .lightGrey,
                fontWeight:
                FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
