
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constants/size_constants.dart';
import '../../blocs/notification/notification_cubit.dart';
import '../../theme/theme_color.dart';
import 'notification_list_item.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w),
      child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if(state is NotificationLoaded) {
              if(state.notifications.isNotEmpty) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return NotificationListItem(
                        notification: notification,
                      );
                    }
                );
              }else {
                return Center(
                  child: Text('No Notifications Available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }

            }else if(state is NotificationLoading) {
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Shimmer.fromColors(
                        baseColor: AppColor.white.withOpacity(0.1),
                        highlightColor: AppColor.white.withOpacity(0.2),
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
                          baseColor: AppColor.white.withOpacity(0.1),
                          highlightColor: AppColor.white.withOpacity(0.2),
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
                                baseColor: AppColor.white.withOpacity(0.1),
                                highlightColor: AppColor.white.withOpacity(0.2),
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
            }else if(state is NotificationError) {
              return Center(
                child: Text('Failed to load notifications',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Shimmer.fromColors(
                      baseColor: AppColor.white.withOpacity(0.1),
                      highlightColor: AppColor.white.withOpacity(0.2),
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
                        baseColor: AppColor.white.withOpacity(0.1),
                        highlightColor: AppColor.white.withOpacity(0.2),
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
                              baseColor: AppColor.white.withOpacity(0.1),
                              highlightColor: AppColor.white.withOpacity(0.2),
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
          }
      ),
    );
  }
}
