
import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/document/document_entity.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../domain/entities/authentication/user_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../../utilities/helper/file_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/document_pop_up_menu.dart';
import 'document_list_item.dart';

class DocumentGridItem extends StatelessWidget {
  final Document document;
  const DocumentGridItem({
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppHelpers().documentIcon(documentNameSplit?[documentNameSplit.length-1] ?? ""),
                        width: Sizes.dimen_38.w,

                      ),
                    ],
                  ),

                ),
              ),
              SizedBox(height: Sizes.dimen_3.h,),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                      child: Tooltip(
                        message: document.filename ?? "--",
                        textStyle: Theme.of(
                            context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                            color: AppColor
                                .purple,
                            fontWeight:
                            FontWeight.bold),
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
                        child: Text(document.filename ?? "--",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
              Text("${DateFormat(user?.dateFormat).format(DateTime.parse(document.updated ?? '2023-01-01')).replaceAll("-", " ")}  ${AppHelpers().convertInStringByteRepresentation(document.size ?? "0")}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColor.grey,fontWeight: FontWeight.bold,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        );
      }
    );
  }
}
