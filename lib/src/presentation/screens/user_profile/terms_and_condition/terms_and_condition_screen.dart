
import 'package:asset_vantage/src/presentation/widgets/av_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../blocs/loading/loading_cubit.dart';
import '../../../theme/theme_color.dart';
import 'terms_and_conditions_webview.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<LoadingCubit>().hide();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: SvgPicture.asset('assets/svgs/bg_graphics.svg',
                fit: BoxFit.fitWidth,
                color: AppColor.grey.withOpacity(0.4),
              ),
            ),
            Column(
              children: [
                AVAppBar(
                  elevation: true,
                  title: 'Terms & Conditions',
                ),
                const Expanded(
                    child: TermsAndConditionWebView()
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
