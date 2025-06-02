
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document_search/document_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/size_constants.dart';
import '../../theme/theme_color.dart';
import 'document_list_item.dart';

class DocumentSearchDelegate extends SearchDelegate {
  final DocumentSearchCubit documentSearchCubit;
  final EntityData? entity;

  DocumentSearchDelegate({this.entity, required this.documentSearchCubit});

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: query.isEmpty ? AppColor.white : AppColor.grey,
        ),
        onPressed: query.isEmpty ? null : () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: AppColor.grey,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.trim().isNotEmpty) {
      documentSearchCubit.searchDocument(context: context, selectedEntity: entity, query: query.trim(), limit: '200', startFrom: '0');
    }

    return BlocBuilder<DocumentSearchCubit, DocumentSearchState>(
        bloc: documentSearchCubit,
        builder: (context, state) {
          if(state is DocumentSearchLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h, horizontal: Sizes.dimen_7.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h, horizontal: Sizes.dimen_12.w),
                    child: Text('${state.documents.length} Results found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if(state.documents.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.documents.length,
                          itemBuilder: (context, index) {
                            final item = state.documents[index];
                            return DocumentListItem(
                              document: item,
                            );
                          }
                      ),
                    )
                  else
                    Expanded(
                      child: Center(
                        child: Text('No result found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    )
                ],
              ),
            );
          }else if(state is DocumentSearchLoading){
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 16,
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
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
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
                        Expanded(
                            flex: 4,
                            child: Container()
                        )
                      ],
                    ),
                  );
                }
            );
          }else if(state is DocumentSearchError) {
            return Center(
              child: Text('No result found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return const SizedBox.shrink();
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}