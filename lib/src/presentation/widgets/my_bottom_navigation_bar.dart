import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../theme/theme_color.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final Function(int) onPressed;
  final int index;
  const MyBottomNavigationBar({super.key, required this.onPressed, required this.index});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10,
      enableFeedback: true,
      selectedLabelStyle: Theme.of(context).textTheme.bodySmall,
      unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
      showUnselectedLabels: true,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: AppColor.grey,
      onTap: widget.onPressed,
      currentIndex: widget.index,
      items: [
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/favorite_left.svg', width: widget.index == 0 ? Sizes.dimen_32.w : Sizes.dimen_28.w, color: widget.index == 0 ? AppColor.primary : AppColor.grey),
            label: 'Favorites'
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/av_middle.svg', width: widget.index == 1 ? Sizes.dimen_58.w : Sizes.dimen_58.w, color: widget.index == 1 ? AppColor.primary : AppColor.grey,),
            label: ''
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/browse_right.svg', width: widget.index == 2 ? Sizes.dimen_32.w : Sizes.dimen_28.w, color: widget.index == 2 ? AppColor.primary : AppColor.grey,),
            label: 'Browse'
        )
      ],
    );
  }
}
