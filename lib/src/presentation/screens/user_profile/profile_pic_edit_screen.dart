import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../arguments/crop_image_argument.dart';
import '../../theme/theme_color.dart';
import '../../widgets/av_app_bar.dart';

class ProfilePicEditScreen extends StatefulWidget {
  final CropImageArgument? argument;
  const ProfilePicEditScreen({super.key, required this.argument});

  @override
  State<ProfilePicEditScreen> createState() => _ProfilePicEditScreenState();
}

class _ProfilePicEditScreenState extends State<ProfilePicEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: LayoutBuilder(
            builder: (context, constraints) {
              return OrientationBuilder(
                  builder: (context, orientation) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SvgPicture.asset('assets/svgs/bg_graphics.svg',
                            width: ScreenUtil().screenWidth,
                            color: AppColor.grey.withOpacity(0.6),
                          ),
                        ),
                        Column(
                          children: [
                            AVAppBar(
                              elevation: true,
                              title: 'Crop Image',
                            ),

                          ],
                        ),
                      ],
                    );
                  }
              );
            }
        ),
      ),
    );
  }
}
