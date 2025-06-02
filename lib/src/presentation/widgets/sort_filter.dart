import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/constants/size_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import '../theme/theme_color.dart';

class SortFilter extends StatefulWidget {
  final Function(int) onSelect;
  final List<PopupMenuItem<int>> menu;
  final String sortName;
  final bool isDissable;
  const SortFilter({
    super.key,
    required this.onSelect,
    required this.menu,
    required this.sortName,
    required this.isDissable,
  });

  @override
  State<SortFilter> createState() => _SortFilterState();
}

class _SortFilterState extends State<SortFilter> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => widget.menu,
      onSelected: widget.isDissable ? null : widget.onSelect,
      offset: const Offset(0, 50),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_12.w,
          vertical: Sizes.dimen_2.h,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/sort_icon.svg',
              width: Sizes.dimen_14,
              height: Sizes.dimen_14,
              color: widget.isDissable ? AppColor.grey.withValues(alpha: 0.8) : null,
            ),
            UIHelper.horizontalSpaceSmall,
            Text(widget.sortName,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold, color: widget.isDissable ? AppColor.grey.withValues(alpha: 0.8) : null)),
          ],
        ),
      ),
    );
  }

}
