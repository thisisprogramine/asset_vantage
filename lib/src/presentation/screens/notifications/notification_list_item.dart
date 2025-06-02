

import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/entities/notification/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/constants/size_constants.dart';
import '../../../domain/entities/authentication/user_entity.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/authentication/user/user_cubit.dart';
import '../../theme/theme_color.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationData notification;
  const NotificationListItem({
    Key? key,
    required this.notification
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserEntity?>(
      builder: (context, user) {
        return ListTile(
          leading: SvgPicture.asset('assets/svgs/notification.svg',
            width: Sizes.dimen_24.w,
            color: context.read<AppThemeCubit>().state?.dashboard?.iconColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.dashboard!.iconColor!)) : AppColor.primary,
          ),
          title: Text(notification.message ?? '--',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(DateFormat(user?.dateFormat).format(DateTime.parse(notification.timeStamp ?? '2023-01-01')) ?? '--',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColor.grey),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: context.read<AppThemeCubit>().state?.dashboard?.iconColor != null ? Color(int.parse(context.read<AppThemeCubit>().state!.dashboard!.iconColor!)) : AppColor.primary, size: Sizes.dimen_16.sp,),
        );
      }
    );
  }
}