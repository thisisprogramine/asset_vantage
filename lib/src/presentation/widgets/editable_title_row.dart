import 'package:asset_vantage/src/domain/entities/favorites/favorites_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constants/size_constants.dart';
import '../../utilities/helper/ui_helper.dart';
import '../theme/theme_color.dart';
import 'EditableTitle.dart';

class EditableTitleRow extends StatelessWidget {
  final bool canEdit;
  final Favorite? favorite;
  final String? title;
  final String defaultTitle;
  final void Function() onEditToggle;
  final void Function() onEditComplete;
  final bool isFav;
  final bool isNetworth;

  const EditableTitleRow({super.key,
    required this.canEdit,
    required this.favorite,
    required this.title,
    required this.onEditToggle,
    required this.onEditComplete,
    required this.isFav,
    required this.defaultTitle,  this.isNetworth=false});

  static Widget editableRowWithoutTransform({
      required final bool canEditTransform,
      required final Favorite? favoriteT,
      required final String? titleT,
      required final String defaultTitle,
      required final void Function() onEditToggle,
      required final void Function() onEditComplete,
      required final bool isFavT,
      required BuildContext context
  }){
    return Row(
      children: [
        if (canEditTransform)
          EditableTitle(
              favorite: favoriteT,
              title: titleT,
              callback: onEditComplete
              )
        else
          Flexible(
            child: Semantics(
              identifier: "reportTitle",
              child: Text(
                isFavT
                    ? (titleT ?? defaultTitle)
                    : defaultTitle,
                style: Theme.of(
                    context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight:
                  FontWeight
                      .bold,
                  height: 1,
                ),
                maxLines: 1,
                overflow:
                TextOverflow
                    .ellipsis,
              ),
            ),
          ),
        if (isFavT) ...[
          UIHelper
              .horizontalSpaceSmall,
          GestureDetector(
            onTap: onEditToggle,
            child: Icon(
                canEditTransform
                    ? Icons
                    .close
                    : Icons
                    .edit_note,
                color:
                AppColor
                    .grey,
                size: Sizes
                    .dimen_18
                    .sp),
          )
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        if(canEdit)
          isNetworth ? Container(
            width: ScreenUtil().screenWidth * 0.56,
            child: Transform.translate(
              offset: Offset(0, -11.0),
              child: EditableTitle(
                  favorite: favorite,
                  title: title,
                  callback: onEditComplete
                  ),
            ),
          )
          : Flexible(
            child: Transform.translate(
              offset: Offset(0, -16.0),
              child: EditableTitle(
                  favorite: favorite,
                  title: title,
                  callback: onEditComplete
            ),
          ))
        else
          Flexible(
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              child: Transform.translate(
                offset: Offset(0, -5.0),
                child: Text(
                  isFav ? (title ?? defaultTitle) : defaultTitle,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight
                        .bold,
                    height: 1,
                  ),
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

        if(isFav)
          ...[
            UIHelper.horizontalSpaceSmall,
            Transform.translate(
              offset: isNetworth ? canEdit ? Offset(0, -9.0): Offset(0, -4.0) : canEdit ? Offset(0, -14.0): Offset(0, -3.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onEditToggle,
                child: Semantics(
                  identifier: "EditIcon",
                  container: true,
                  explicitChildNodes: true,
                  child: Container(
                    padding: !canEdit ? EdgeInsets.only(right: Sizes.dimen_12,bottom: Sizes.dimen_6): EdgeInsets.only(right: Sizes.dimen_10,bottom: Sizes.dimen_7,top: Sizes.dimen_6),
                    child: SvgPicture.asset(canEdit ? "assets/svgs/cross.svg" : "assets/svgs/edit_favourite_name.svg",

                    ),
                  ),
                ),
              ),
            )
          ]
      ],
    );
  }
}
