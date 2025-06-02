import 'package:flutter/material.dart';

import '../theme/theme_color.dart';

class PerformanceText extends StatelessWidget {
  final String title;
  const PerformanceText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme
          .of(
          context)
          .textTheme
          .titleSmall
          ?.copyWith(
          color: AppColor
              .grey,
          fontWeight: FontWeight
              .normal),
      textAlign: TextAlign
          .center,
      maxLines: 1,
      overflow: TextOverflow
          .ellipsis,);
  }
}
