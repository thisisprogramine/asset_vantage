import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/screens/dashboard/widget_selection_sheet.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPersonalisation extends StatefulWidget {
  final ScrollController scrollController;
   DashboardPersonalisation({
     super.key,
     required this.scrollController
   });


  @override
  State<DashboardPersonalisation> createState() => _DashboardPersonalisationState();
}

class _DashboardPersonalisationState extends State<DashboardPersonalisation> {
  void showWidgetSelectionSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Sizes.dimen_12.r)
          )
        ),
        builder: (context) => WidgetSelectionSheet(scrollController: widget.scrollController,));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_18, vertical: Sizes.dimen_6.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.dimen_12.r)
      ),
      elevation: 2,
      color: AppColor.white,
      child: Padding(
        padding: EdgeInsets.only(left: Sizes.dimen_17.w,right: Sizes.dimen_28.w,top: Sizes.dimen_16,bottom: Sizes.dimen_16),
        child: Row(
          children: [
            Expanded(
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(StringConstants.personaliseDashboard,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize:Sizes.dimen_16.sp
                  ),),
                 SizedBox(height: Sizes.dimen_2,),
                  Text(StringConstants.personaliseDashboardCustomisedView,style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColor.textGrey.withValues(alpha: 0.8),
                    fontSize: Sizes.dimen_14.sp
                  ),),
                  SizedBox(height: Sizes.dimen_14,),
                  ElevatedButton(
                    onPressed: (){
                      showWidgetSelectionSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.textGrey,
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.dimen_20.w,
                        vertical: Sizes.dimen_4.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.dimen_8.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          StringConstants.startPersonalising,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColor.white,
                            fontSize: Sizes.dimen_14.sp,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(width: Sizes.dimen_8.w),
                        Icon(
                          Icons.arrow_forward,
                          size: Sizes.dimen_17.sp,
                          color: AppColor.white,
                          weight: Sizes.dimen_300.sp,),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomLeft,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.green.withValues(alpha: 0.5),
                        AppColor.green.withValues(alpha: 0.1),
                      ],
                    ).createShader(bounds);
                  },
                  child: SvgPicture.asset('assets/svgs/personalise_bar.svg',
                    height: Sizes.dimen_70,
                    width:Sizes.dimen_26,
                    color: Colors.green.shade100,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 0,
                    left: 0,
                    child: SvgPicture.asset('assets/svgs/personalise_bar_arrow.svg',
                      width: Sizes.dimen_100.w,
                    fit: BoxFit.contain,))
              ],
            )
          ],
        ),
      ),

    );
  }
}
