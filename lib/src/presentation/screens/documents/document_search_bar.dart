import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document_search/document_search_cubit.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/document/document_filter/document_filter_cubit.dart';
import '../../blocs/document/document_sort/document_view_cubit.dart';
import '../../blocs/document/document_view/document_view_cubit.dart';
import '../../theme/theme_color.dart';
import 'document_search_delegate.dart';

class DocumentSearchBar extends StatefulWidget {
  final void Function(String) onChange;

  const DocumentSearchBar({Key? key, required this.onChange,}) : super(key: key);

  @override
  State<DocumentSearchBar> createState() => _DocumentSearchBarState();
}

class _DocumentSearchBarState extends State<DocumentSearchBar> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showSearch(
              context: context,
              delegate: DocumentSearchDelegate(
                  entity:
                      context.read<DocumentFilterCubit>().state.selectedFilter,
                  documentSearchCubit: context.read<DocumentSearchCubit>()));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.dimen_8),
          ),
          margin: EdgeInsets.symmetric(
              vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_7.w),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_1.h),
            child: Row(
              children: [
                UIHelper.horizontalSpaceLarge,
                SvgPicture.asset(
                  'assets/svgs/search.svg',
                  height: Sizes.dimen_16.w,
                  width: Sizes.dimen_16.w,
                  color: AppColor.grey.withValues(alpha: 0.4),
                ),
                Expanded(
                  child: TextFormField(
                    key: widget.key,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColor.grey,
                          fontWeight: FontWeight.bold,
                        ),
                    focusNode: _node,
                    onTapOutside: (event) => _node.unfocus(),
                    cursorColor: AppColor.grey,
                    textAlignVertical: TextAlignVertical.center,
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    onChanged: widget.onChange,
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColor.grey.withValues(alpha: 0.4),
                            fontWeight: FontWeight.normal,
                          ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Sizes.dimen_3.h, horizontal: Sizes.dimen_7.w),
                      isDense: true,
                      border: InputBorder.none,
                      prefixIconConstraints: BoxConstraints(),
                      suffixIconConstraints: BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
