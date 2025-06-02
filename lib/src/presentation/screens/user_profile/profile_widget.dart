import 'dart:io';

import 'package:asset_vantage/src/config/constants/route_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../arguments/crop_image_argument.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';

class ProfileWidget extends StatelessWidget {
  final bool isLandscape;
  final String profile;
  const ProfileWidget(
      {Key? key, this.isLandscape = false, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UIHelper.verticalSpaceSmall,
        Row(
          children: [
            Expanded(
              child: BlocBuilder<UserCubit, UserEntity?>(builder: (context, user) {
                            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                    child: Image.asset("assets/pngs/account.png", width: Sizes.dimen_140, color: AppColor.primary,),
                  ),
                ),
              ],
                            );
                          }),
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_16.w),
            child:
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<UserCubit, UserEntity?>(builder: (context, user) {
                                    return Text(
                      user?.displayname ?? '--',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: Sizes.dimen_26.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                                    );
                                  }),
                    ),
                  ],
                )),
      ],
    );
  }

  showProfilePicture(
      {required BuildContext context,
      required String name,
      required String image}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor:
                context.read<AppThemeCubit>().state?.card?.color != null
                    ? Color(int.parse(
                        context.read<AppThemeCubit>().state!.card!.color!))
                    : AppColor.onVulcan,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.dimen_12.w)),
            title: Text(
              name,
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_0.w),
            titlePadding: EdgeInsets.symmetric(
                vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_4.w),
            titleTextStyle: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context
                                .read<AppThemeCubit>()
                                .state
                                ?.filter
                                ?.iconColor !=
                            null
                        ? Color(int.parse(context
                            .read<AppThemeCubit>()
                            .state!
                            .filter!
                            .iconColor!))
                        : AppColor.primary),
            children: [
              Image.network(image),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: Text(
                    'Close',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context
                                    .read<AppThemeCubit>()
                                    .state
                                    ?.filter
                                    ?.iconColor !=
                                null
                            ? Color(int.parse(context
                                .read<AppThemeCubit>()
                                .state!
                                .filter!
                                .iconColor!))
                            : AppColor.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          );
        });
  }

  Future<void> openImageDocuments({required BuildContext context}) async {
    String? pickerType = await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Sizes.dimen_10),
          ),
        ),
        builder: (context) =>
            OrientationBuilder(builder: (context, orientation) {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Sizes.dimen_10),
                        topRight: Radius.circular(Sizes.dimen_10))),
                height: ScreenUtil().screenHeight *
                    (orientation == Orientation.landscape ? 0.50 : 0.30),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Edit Profile Picture',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      UIHelper.verticalSpaceMedium,
                      Expanded(
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context, 'camera'),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: Sizes.dimen_2.w,
                                              color: context
                                                          .read<AppThemeCubit>()
                                                          .state
                                                          ?.filter
                                                          ?.iconColor !=
                                                      null
                                                  ? Color(int.parse(context
                                                      .read<AppThemeCubit>()
                                                      .state!
                                                      .filter!
                                                      .iconColor!))
                                                  : AppColor.primary),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_8.h,
                                                horizontal: Sizes.dimen_18.w),
                                            child: Icon(Icons.camera_alt,
                                                size: Sizes.dimen_32.w)),
                                      ),
                                      UIHelper.verticalSpace(Sizes.dimen_2.h),
                                      Text(
                                        'Camera',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pop(context, 'gallery'),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: Sizes.dimen_2.w,
                                              color: context
                                                          .read<AppThemeCubit>()
                                                          .state
                                                          ?.filter
                                                          ?.iconColor !=
                                                      null
                                                  ? Color(int.parse(context
                                                      .read<AppThemeCubit>()
                                                      .state!
                                                      .filter!
                                                      .iconColor!))
                                                  : AppColor.primary),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_8.h,
                                                horizontal: Sizes.dimen_18.w),
                                            child: Icon(Icons.photo,
                                                size: Sizes.dimen_32.w)),
                                      ),
                                      UIHelper.verticalSpace(Sizes.dimen_2.h),
                                      Text(
                                        'Gallery',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context, 'remove'),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: Sizes.dimen_2.w,
                                              color: context
                                                          .read<AppThemeCubit>()
                                                          .state
                                                          ?.filter
                                                          ?.iconColor !=
                                                      null
                                                  ? Color(int.parse(context
                                                      .read<AppThemeCubit>()
                                                      .state!
                                                      .filter!
                                                      .iconColor!))
                                                  : AppColor.primary),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Sizes.dimen_8.h,
                                                horizontal: Sizes.dimen_18.w),
                                            child: Icon(Icons.delete,
                                                size: Sizes.dimen_32.w)),
                                      ),
                                      UIHelper.verticalSpace(Sizes.dimen_2.h),
                                      Text(
                                        'Remove',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
    XFile? picker;
    if (pickerType == 'camera') {
      picker = await ImagePicker().pickImage(source: ImageSource.camera);
      if (picker != null) {
      }
    } else if (pickerType == 'gallery') {
      picker = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picker != null) {
      }
    } else if (pickerType == 'remove') {
    } else {
      print("Select None");
    }
  }

  void showRemoveDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: context.read<AppThemeCubit>().state?.card?.color !=
                  null
              ? Color(
                  int.parse(context.read<AppThemeCubit>().state!.card!.color!))
              : AppColor.onVulcan,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.dimen_12.w)),
          contentPadding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_0.h, horizontal: Sizes.dimen_0.w),
          titlePadding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_4.w),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.read<AppThemeCubit>().state?.filter?.iconColor !=
                      null
                  ? Color(int.parse(
                      context.read<AppThemeCubit>().state!.filter!.iconColor!))
                  : AppColor.primary),
          children: [
            UIHelper.verticalSpaceSmall,
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_12.w),
                child: Text(
                  'Do you want to remove profile picture?',
                  style: Theme.of(context).textTheme.titleSmall,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context
                                    .read<AppThemeCubit>()
                                    .state
                                    ?.filter
                                    ?.iconColor !=
                                null
                            ? Color(int.parse(context
                                .read<AppThemeCubit>()
                                .state!
                                .filter!
                                .iconColor!))
                            : AppColor.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                UIHelper.horizontalSpaceSmall,
                TextButton(
                    child: Text(
                      'Remove',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context
                                      .read<AppThemeCubit>()
                                      .state
                                      ?.filter
                                      ?.iconColor !=
                                  null
                              ? Color(int.parse(context
                                  .read<AppThemeCubit>()
                                  .state!
                                  .filter!
                                  .iconColor!))
                              : AppColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      print("Remove");
                      Navigator.pop(context);
                    })
              ],
            )
          ],
        );
      },
    );
  }
}
