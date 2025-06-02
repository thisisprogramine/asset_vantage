import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController textController;
  final Key? feildKey;
  const SearchBarWidget({super.key,
    required this.textController,
    required this.feildKey,
    required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            child: Semantics(
              identifier: "searchBar",
              child: TextFormField(
                key: feildKey,
                controller: textController,
                textInputAction: TextInputAction.search,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: Sizes.dimen_15.sp,
                ),
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
        ),
      ],
    );
  }
}
