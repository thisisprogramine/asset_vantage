import 'dart:developer';
import 'dart:io';

import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/constants/strings_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/arguments/document_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document_filter/document_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/drill_down_back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/route_constants.dart';
import '../../../injector.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/document/document/document_cubit.dart';
import '../../blocs/document/document_search/document_search_cubit.dart';
import '../../blocs/document/document_sort/document_view_cubit.dart';
import '../../blocs/document/document_view/document_view_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/av_app_bar.dart';
import '../navigation_drawer/NavigationDrawer.dart';
import 'document_entity_filter.dart';
import 'document_list.dart';
import 'document_search_bar.dart';

class DocumentsScreen extends StatefulWidget {
  final DocumentArgument argument;
  const DocumentsScreen({Key? key, required this.argument}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late DocumentFilterCubit documentFilterCubit;
  late DocumentCubit documentCubit;
  late DocumentViewCubit documentViewCubit;
  late DocumentSearchCubit documentSearchCubit;
  late DocumentSortCubit documentSortCubit;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = Tween<double>(begin: 0, end: 0.5)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  String searchText = '';
  bool? up;

  @override
  void initState() {
    super.initState();
    documentFilterCubit = getItInstance<DocumentFilterCubit>();
    documentViewCubit = getItInstance<DocumentViewCubit>();
    documentSearchCubit = getItInstance<DocumentSearchCubit>();
    documentSortCubit = getItInstance<DocumentSortCubit>();
    documentCubit = documentFilterCubit.documentCubit;
    documentFilterCubit.loadDocumentEntities(
      context: context,
    );
    _scrollController.addListener(
      () {
        if (_scrollController.hasClients) {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent ||
              _scrollController.offset <=
                  _scrollController.position.minScrollExtent) {
            up = null;
          } else if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            up = true;
            _controller.forward();
          } else if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            up = false;
            _controller.reverse();
          }
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    documentFilterCubit.close();
    documentCubit.close();
    documentViewCubit.close();
    documentSearchCubit.close();
    documentSortCubit.close();
    _scrollController.dispose();
    _scrollController.removeListener(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => documentCubit,
        ),
        BlocProvider(
          create: (context) => documentFilterCubit,
        ),
        BlocProvider(
          create: (context) => documentViewCubit,
        ),
        BlocProvider(
          create: (context) => documentSearchCubit,
        ),
        BlocProvider(
          create: (context) => documentSortCubit,
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          return BlocBuilder<DocumentCubit, DocumentState>(
            builder: (context, state) {
              return Scaffold(
                floatingActionButton: up != null
                    ? FloatingActionButton.small(
                        onPressed: () {
                          if (up == true) {
                            print("Going to bottom");
                            _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          }
                          else {
                            print("Going to top");
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: RotationTransition(
                          turns: _animation,
                          child: const Icon(Icons.arrow_downward),
                        ),
                      )
                    : null,
                backgroundColor: AppColor.scaffoldBackground,
                drawer: const AVNavigationDrawer(),
                drawerEnableOpenDragGesture: false,
                appBar: AVAppBar(
                  title: "Documents(${state is DocumentLoaded ? state.documents.where(
                        (element) => (element.filename ?? "")
                        .toLowerCase()
                        .contains(searchText.toLowerCase()),
                  ).toList().length : 0})",
                  leading: DrillDownBackArrow(onTap: () {
                    Navigator.of(context).pop();
                  },)
                ),
                body: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
                        child: DocumentSearchBar(onChange: (String text) {
                          searchText = text;
                          setState(() {});
                        }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_24.w),
                              child: DocumentEntityFilter(
                                isIpad: !(constraints.maxWidth < 600),
                                documentFilterCubit: documentFilterCubit,
                              ),
                            ),
                          ),
                          BlocBuilder<DocumentViewCubit, ViewType>(
                              builder: (context, state) {
                                return GestureDetector(
                                    onTap: () {
                                      if (state == ViewType.grid) {
                                        context
                                            .read<DocumentViewCubit>()
                                            .documentViewChange(ViewType.list);
                                      } else {
                                        context
                                            .read<DocumentViewCubit>()
                                            .documentViewChange(ViewType.grid);
                                      }
                                    },
                                    child: state == ViewType.grid
                                        ? SvgPicture.asset(
                                      'assets/svgs/document_menu_list.svg',
                                      width: Sizes.dimen_18
                                          .w,
                                      color: AppColor.lightGrey,
                                    )
                                        : SvgPicture.asset(
                                      'assets/svgs/document_menu_grid.svg',
                                      width: Sizes.dimen_18.w,
                                      color: AppColor.lightGrey,
                                    ));
                              }),
                          BlocBuilder<DocumentSortCubit, Sort>(
                              builder: (context, state) {
                                return PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_2.h,
                                          horizontal: Sizes.dimen_12.w),
                                      value: 1,
                                      child: SizedBox(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    StringConstants.documentNameAZ,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                if (state == Sort.az)
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                        Sizes.dimen_4.h,
                                                        horizontal: Sizes
                                                            .dimen_0.w),
                                                    child: Icon(
                                                      Icons.check_rounded,
                                                      color: AppColor.primary,
                                                      size: Sizes.dimen_24.w,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_2.h,
                                          horizontal: Sizes.dimen_12.w),
                                      value: 2,
                                      child: SizedBox(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    StringConstants.documentNameZA,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                if (state == Sort.za)
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                        Sizes.dimen_4.h,
                                                        horizontal: Sizes
                                                            .dimen_0.w),
                                                    child: Icon(
                                                      Icons.check_rounded,
                                                      color: AppColor.primary,
                                                      size: Sizes.dimen_24.w,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_2.h,
                                          horizontal: Sizes.dimen_12.w),
                                      value: 3,
                                      child: SizedBox(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    StringConstants.documentNewestFirst,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                if (state == Sort.latest)
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                        Sizes.dimen_4.h,
                                                        horizontal: Sizes
                                                            .dimen_0.w),
                                                    child: Icon(
                                                      Icons.check_rounded,
                                                      color: AppColor.primary,
                                                      size: Sizes.dimen_24.w,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dimen_2.h,
                                          horizontal: Sizes.dimen_12.w),
                                      value: 4,
                                      child: SizedBox(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    StringConstants.documentOldestFirst,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                if (state == Sort.oldest)
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                        Sizes.dimen_4.h,
                                                        horizontal: Sizes
                                                            .dimen_0.w),
                                                    child: Icon(
                                                      Icons.check_rounded,
                                                      color: AppColor.primary,
                                                      size: Sizes.dimen_24.w,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  onSelected: (int index) async {
                                    if (index == 1) {
                                      context
                                          .read<DocumentSortCubit>()
                                          .documentSortChange(Sort.az);
                                    } else if (index == 2) {
                                      context
                                          .read<DocumentSortCubit>()
                                          .documentSortChange(Sort.za);
                                    } else if (index == 3) {
                                      context
                                          .read<DocumentSortCubit>()
                                          .documentSortChange(Sort.latest);
                                    } else if (index == 4) {
                                      context
                                          .read<DocumentSortCubit>()
                                          .documentSortChange(Sort.oldest);
                                    }
                                  },
                                  offset: const Offset(0, 50),
                                  elevation: 2,
                                  icon: SvgPicture.asset(
                                    'assets/svgs/sort_icon_for document.svg',
                                    width: Sizes.dimen_18.w,
                                    color: AppColor.lightGrey,
                                  ),
                                );
                              }),
                          UIHelper.horizontalSpace(Sizes.dimen_8.w)
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.dimen_12.w,
                      ),
                      sliver: DocumentList(
                          searchText: searchText,
                          orientation: orientation,
                          isIpad: constraints.maxWidth > 600 &&
                              constraints.maxHeight > 600),
                    ),
                  ],
                ),
              );
            }
          );
        });
      }),
    );
  }
}
