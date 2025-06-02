import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import '../../config/constants/size_constants.dart';

class FilterPersonalizationHint extends StatelessWidget {
  const FilterPersonalizationHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_1.h, horizontal: Sizes.dimen_0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.dimen_6),
        ),
        child:Text(StringConstants.personalisationHint, style: Theme.of(context).textTheme.bodyLarge,)
    );
  }
}
