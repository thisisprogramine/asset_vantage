
import 'package:asset_vantage/src/presentation/av_app.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constants/size_constants.dart';
import '../../domain/entities/favorites/favorites_entity.dart';
import '../theme/theme_color.dart';

class EditableTitle extends StatefulWidget {
  final Key? key;
  final String? title;
  final Favorite? favorite;
  final void Function() callback;

  const EditableTitle({
    this.key,
    required this.favorite,
    required this.title,
    required this.callback,
  }) : super(key: key);

  @override
  _LoginInputFieldState createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<EditableTitle> {
  late TextEditingController _textEditingController;
  bool processing = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if(state is FavoritesLoaded){
          processing = state.nameLoading!=null && state.nameLoading?.id==widget.favorite?.id;
          return Semantics(
            identifier: "EditTextField",
            child: SizedBox(
              height: Sizes.dimen_12.h,
              width: ScreenUtil().screenWidth * 0.7,
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets
                      .symmetric(
                    vertical:
                    Sizes.dimen_2.h,
                    horizontal: Sizes
                        .dimen_12.w,
                  ),
                  suffixIconConstraints:
                  BoxConstraints(),
                  suffixIconColor:
                  AppColor.primary,
                  suffixIcon: processing
                      ? Container(
                    height: Sizes
                        .dimen_6
                        .h,
                    width: Sizes
                        .dimen_6
                        .h,
                    margin: EdgeInsets.symmetric(
                        vertical: Sizes
                            .dimen_1
                            .h,
                        horizontal: Sizes
                            .dimen_8
                            .w),
                    child: const CircularProgressIndicator(
                        strokeAlign:
                        1.0,
                        strokeWidth:
                        2),
                  )
                      : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.read<FavoritesCubit>().updateFavoriteReportName(context: context, favorite: widget.favorite, reportName: _textEditingController.text).then((value) => widget.callback(),);
                    },
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes
                              .dimen_1
                              .h,
                          horizontal: Sizes
                              .dimen_8
                              .w),
                      child: Icon(
                          Icons
                              .done,
                          size: Sizes
                              .dimen_20
                              .sp),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius
                          .circular(Sizes
                          .dimen_6
                          .r),
                      borderSide: BorderSide(
                          color:
                          AppColor
                              .grey,
                          width: Sizes
                              .dimen_1
                              .w)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius
                          .circular(Sizes
                          .dimen_6
                          .r),
                      borderSide: BorderSide(
                          color:
                          AppColor
                              .grey,
                          width: Sizes
                              .dimen_1
                              .w)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius
                          .circular(Sizes
                          .dimen_6
                          .r),
                      borderSide: BorderSide(
                          color:
                          AppColor
                              .grey,
                          width: Sizes
                              .dimen_1
                              .w)),
                  errorBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(Sizes
                          .dimen_6
                          .r),
                      borderSide: BorderSide(
                          color:
                          AppColor
                              .red,
                          width: Sizes
                              .dimen_1
                              .w)),
                ),
                controller:
                _textEditingController,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
                onTapOutside: (_) =>
                    FocusScope.of(
                        context)
                        .unfocus(),
                maxLines: 1,
                textInputAction:
                TextInputAction
                    .done,
                readOnly: processing,
                validator: (value) {
                  if (value == null ||
                      value
                          .trim()
                          .isEmpty) {
                    return "Enter a name";
                  }
                  return null;
                },
                keyboardType:
                TextInputType.text,
              ),
            ),
          );
        }
        return Container();
      }
    );

  }
}
