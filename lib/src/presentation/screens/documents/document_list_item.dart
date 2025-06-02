

import 'dart:math';

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/document/document_entity.dart';
import 'package:asset_vantage/src/presentation/widgets/document_pop_up_menu.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:asset_vantage/src/utilities/helper/file_helper.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../theme/theme_color.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;
  const DocumentListItem({
    Key? key,
    required this.document
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserEntity?>(
      builder: (context, user) {
        final documentNameSplit = document.filename?.split(".");
        return GestureDetector(
          onTap: () {
          },
          child: Card(
            margin: EdgeInsets.only(bottom: Sizes.dimen_6.h),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_22.w, vertical: Sizes.dimen_6.h),
              child: Row(
                children: [
                  SvgPicture.asset(AppHelpers().documentIcon(documentNameSplit?[documentNameSplit.length-1] ?? ""),
                    width: Sizes.dimen_36.w,

                  ),
                  UIHelper.horizontalSpaceMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Tooltip(
                                message:
                                document.filename ?? '--',
                                textStyle: Theme.of(
                                    context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                    ),
                                preferBelow:
                                false,
                                decoration: BoxDecoration(
                                    color: AppColor
                                        .white,
                                    border: Border.all(
                                        color: AppColor
                                            .textGrey),
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0)),
                                child: Text(document.filename ?? '--',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DocumentPopUpMenu(
                                onTapView: (){
                                  FileHelper.openFile(context: context, document: document);
                                },
                                onTapShare: (){
                                  FileHelper.shareFile(context: context, document: document);
                                },
                                onTapDownload: (){
                                  FileHelper.downloadFile(context: context, document: document);
                                })
                          ],
                        ),
                        UIHelper.verticalSpace(Sizes.dimen_1.h),
                        Text("${DateFormat(user?.dateFormat).format(DateTime.parse(document.updated ?? '2023-01-01'))}  ${AppHelpers().convertInStringByteRepresentation(document.size ?? "0")}",
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    ),
                  ),

                ],
              ),
            )
          ),
        );
      }
    );
  }
}

class DocumentOptionList extends StatelessWidget {
  final Document document;

  const DocumentOptionList({super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight * 0.4,
      padding: EdgeInsets.only(top: Sizes.dimen_4.h,right: Sizes.dimen_12.w,left: Sizes.dimen_12.w,),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (Sizes.dimen_3/1.3).h,
              width: Sizes.dimen_48.w,
              decoration: BoxDecoration(
                color: AppColor.lightGrey,
                borderRadius: BorderRadius.circular(Sizes.dimen_20.w),
              ),
            ),
            Card(
              elevation: 0,
              color: AppColor.transparent,
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: () {
                  FileHelper.openFile(context: context, document: document);
                  Navigator.of(context).pop();
                },
                leading: SvgPicture.asset('assets/svgs/eye.svg',
                  height: Sizes.dimen_22.w,color: AppColor.grey,),
                title: Text("View",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,color: AppColor.grey,),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Divider(color: AppColor.grey,thickness: 0.4,height: 0.4,indent: Sizes.dimen_18.w,endIndent: Sizes.dimen_18.w,),
            Card(
              elevation: 0,
              color: AppColor.transparent,
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: () {
                  FileHelper.shareFile(context: context, document: document);
                  Navigator.of(context).pop();
                },
                leading: SvgPicture.asset('assets/svgs/share_icon.svg',
                  height: Sizes.dimen_20.w,color: AppColor.grey,),

                title: Text("Share",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,color: AppColor.grey,),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Divider(color: AppColor.grey,thickness: 0.4,height: 0.4,indent: Sizes.dimen_18.w,endIndent: Sizes.dimen_18.w,),
            Card(
              elevation: 0,
              color: AppColor.transparent,
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: () {
                  FileHelper.downloadFile(context: context, document: document);
                  Navigator.of(context).pop();
                },
                leading: SvgPicture.asset('assets/svgs/download_icon.svg',
                  height: Sizes.dimen_19.w,color: AppColor.grey,),
                title: Text("Download",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,color: AppColor.grey,),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

