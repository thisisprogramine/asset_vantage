import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document/document_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document_view/document_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/document/document_entity.dart';
import '../../../utilities/helper/app_helper.dart';
import '../../blocs/document/document_sort/document_view_cubit.dart';
import '../../theme/theme_color.dart';
import 'document_grid_item.dart';
import 'document_list_item.dart';

class DocumentList extends StatefulWidget {
  final bool isIpad;
  final Orientation orientation;
  final String searchText;
  const DocumentList({
    Key? key,
    required this.isIpad,
    required this.orientation,
    required this.searchText,
  }) : super(key: key);

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _animation1;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animation1 = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_7.w),
      sliver:
          BlocBuilder<DocumentCubit, DocumentState>(builder: (context, state) {
        if (state is DocumentLoaded) {
          final documentsToView = state.documents
              .where(
                (element) =>
                    (element.filename ?? "").toLowerCase().contains(widget.searchText.toLowerCase()),
              )
              .toList();
          if (documentsToView.isNotEmpty) {
            final List<Document> documentList = documentsToView;
            return BlocBuilder<DocumentSortCubit, Sort>(
                builder: (context, sortState) {
              if (sortState == Sort.az) {
                documentList.sort((a, b) {
                  return a.filename
                          ?.toLowerCase()
                          .compareTo(b.filename?.toLowerCase() ?? '') ??
                      0;
                });
              } else if (sortState == Sort.za) {
                documentList.sort((a, b) {
                  return b.filename
                          ?.toLowerCase()
                          .compareTo(a.filename?.toLowerCase() ?? '') ??
                      0;
                });
              } else if (sortState == Sort.latest) {
                documentList.sort((a, b) {
                  return b.updated
                          ?.toLowerCase()
                          .compareTo(a.updated?.toLowerCase() ?? '') ??
                      0;
                });
              } else if (sortState == Sort.oldest) {
                documentList.sort((a, b) {
                  return a.updated
                          ?.toLowerCase()
                          .compareTo(b.updated?.toLowerCase() ?? '') ??
                      0;
                });
              }
              return BlocBuilder<DocumentViewCubit, ViewType>(
                  builder: (context, viewState) {
                if (viewState == ViewType.grid) {
                  _animationController.forward();
                } else if (viewState == ViewType.list) {
                  _animationController.reverse();
                }
                return viewState == ViewType.grid ?
                SliverFadeTransition(
                  opacity: _animation1,
                  sliver: SliverGrid.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.orientation ==
                            Orientation.landscape
                            ? 6
                            : 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 22.0,
                        mainAxisExtent: 200.0,
                      ),
                      itemCount: documentList.length,
                      itemBuilder: (context, index) {
                        final docs = documentList[index];
                        return DocumentGridItem(
                          document: docs,
                        );
                      }),
                )
                    : SliverFadeTransition(
                        opacity: _animation,
                        sliver: SliverList.builder(
                            itemCount: documentList.length,
                            itemBuilder: (context, index) {
                              final docs = documentList[index];
                              return DocumentListItem(
                                document: docs,
                              );
                            }),
                      );
              });
            });
          } else {
            return SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'No Documents Available',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }
        } else if (state is DocumentLoading) {
          return SliverList.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Shimmer.fromColors(
                    baseColor: AppColor.grey.withOpacity(0.1),
                    highlightColor: AppColor.grey.withOpacity(0.2),
                    direction: ShimmerDirection.ltr,
                    period: Duration(seconds: 1),
                    child: Container(
                      width: Sizes.dimen_16.h,
                      height: Sizes.dimen_16.h,
                      decoration: BoxDecoration(
                        color: AppColor.lightGrey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                    child: Shimmer.fromColors(
                      baseColor: AppColor.grey.withOpacity(0.1),
                      highlightColor: AppColor.grey.withOpacity(0.2),
                      direction: ShimmerDirection.ltr,
                      period: Duration(seconds: 1),
                      child: Container(
                        width: ScreenUtil().screenWidth * 0.80,
                        height: Sizes.dimen_6.h,
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                          child: Shimmer.fromColors(
                            baseColor: AppColor.grey.withOpacity(0.1),
                            highlightColor: AppColor.grey.withOpacity(0.2),
                            direction: ShimmerDirection.ltr,
                            period: Duration(seconds: 1),
                            child: Container(
                              width: ScreenUtil().screenWidth * 0.60,
                              height: Sizes.dimen_6.h,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 4, child: Container())
                    ],
                  ),
                );
              });
        } else if (state is DocumentError) {
          if (state.errorType == AppErrorType.unauthorised) {
            AppHelpers.logout(context: context);
          }
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Failed to load documents',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }
        return SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Shimmer.fromColors(
                  baseColor: AppColor.grey.withOpacity(0.1),
                  highlightColor: AppColor.grey.withOpacity(0.2),
                  direction: ShimmerDirection.ltr,
                  period: Duration(seconds: 1),
                  child: Container(
                    width: Sizes.dimen_16.h,
                    height: Sizes.dimen_16.h,
                    decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                  child: Shimmer.fromColors(
                    baseColor: AppColor.grey.withOpacity(0.1),
                    highlightColor: AppColor.grey.withOpacity(0.2),
                    direction: ShimmerDirection.ltr,
                    period: Duration(seconds: 1),
                    child: Container(
                      width: ScreenUtil().screenWidth * 0.80,
                      height: Sizes.dimen_6.h,
                      decoration: BoxDecoration(
                        color: AppColor.lightGrey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                        child: Shimmer.fromColors(
                          baseColor: AppColor.grey.withOpacity(0.1),
                          highlightColor: AppColor.grey.withOpacity(0.2),
                          direction: ShimmerDirection.ltr,
                          period: Duration(seconds: 1),
                          child: Container(
                            width: ScreenUtil().screenWidth * 0.60,
                            height: Sizes.dimen_6.h,
                            decoration: BoxDecoration(
                              color: AppColor.lightGrey,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 4, child: Container())
                  ],
                ),
              );
            });
      }),
    );
  }
}
