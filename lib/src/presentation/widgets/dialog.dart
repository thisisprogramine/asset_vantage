import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/app_theme/theme_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constants/size_constants.dart';
import '../../config/constants/tnc_pp.dart';
import '../theme/theme_color.dart';

class AVDialog extends StatefulWidget {
  final String? title;
  final List<Object>? data;
  final String? headerString;
  final void Function()? onClick;
  const AVDialog({super.key, required this.data,this.onClick,this.headerString,required this.title,});

  @override
  State<AVDialog> createState() => _AVDialogState();
}

class _AVDialogState extends State<AVDialog> {
  late int intro;

  @override
  void initState() {
    intro = widget.headerString!=null?1:0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return SimpleDialog(
          backgroundColor: context.read<AppThemeCubit>().state?.card?.color!=null?Color(int.parse(context.read<AppThemeCubit>().state!.card!.color!)):AppColor.onVulcan,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.dimen_12.w)
          ),
          title: Text(widget.title ?? '',textAlign: TextAlign.center,),
          contentPadding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_14.w),
          titlePadding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_6.h,
              horizontal: Sizes.dimen_4.w),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,color: context.read<AppThemeCubit>().state?.filter?.iconColor != null
              ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!))
              : AppColor.primary),
          children: [
          SizedBox(
            height: orientation == Orientation.landscape ? ScreenUtil().screenWidth * 0.5 : ScreenUtil().screenHeight * 0.5,
            width: orientation == Orientation.landscape ? ScreenUtil().screenHeight * 0.8 : ScreenUtil().screenWidth * 0.8,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
              if(widget.headerString!=null && index == 0){
                return Text(widget.headerString!, style: Theme.of(context).textTheme.titleSmall);
              }
              final currentData = widget.data![index-intro];
              if(currentData is HeaderContent){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentData.header ?? '',style: Theme.of(context).textTheme.headlineSmall,),
                    SizedBox(height: Sizes.dimen_8.h,),
                    Text(currentData.content ?? '',style: Theme.of(context).textTheme.titleSmall),
                  ],
                );
              }else if(currentData is HeaderPointerContent) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentData.header ?? '',style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: Sizes.dimen_4.h,),
                    if(currentData.subHeader!=null)
                    Text(currentData.subHeader ?? '',style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: Sizes.dimen_4.h,),
                    ...(currentData.points?.map((e) => ListTile(leading: Icon(Icons.circle, size: Sizes.dimen_8.w,color: Theme.of(context).textTheme.titleMedium?.color,), contentPadding: EdgeInsets.all(0),minLeadingWidth: Sizes.dimen_8.w,title: Text('  $e'??'',style: Theme.of(context).textTheme.titleSmall))).toList() ?? []),
                  ],
                );
              }else if(currentData is HeaderSubContent){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentData.header ?? '',style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: Sizes.dimen_4.h,),
                    ...(currentData.subheaderContent?.map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.header ?? '',style: Theme.of(context).textTheme.titleMedium?.copyWith(decoration: TextDecoration.underline,)),
                        SizedBox(height: Sizes.dimen_4.h,),
                        Text(e.content ?? '',style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: Sizes.dimen_4.h,),
                      ],
                    ))??[])
                  ],
                );
              }else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((currentData as HeaderClickContent).header ?? '',style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: Sizes.dimen_8.h,),
                    RichText(textAlign: TextAlign.left,text: TextSpan(
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        TextSpan(text: currentData.firstContent),
                        TextSpan(text: currentData.clickableText,recognizer: TapGestureRecognizer()..onTap = () {
                          widget.onClick!();
                        },style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).primaryColor)),
                        TextSpan(text: currentData.secondContent),
                      ]
                    )),
                  ],
                );
              }
            }, separatorBuilder: (context, index) => SizedBox(height: Sizes.dimen_16.h,), itemCount: (widget.data?.length ?? 0)+intro ?? 0)
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(child: Text('OK',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: context.read<AppThemeCubit>().state?.filter?.iconColor != null
                ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!))
                : AppColor.primary,fontWeight: FontWeight.bold),),onPressed: ()=> Navigator.pop(context),),
          )
        ],);
      }
    );
  }
}