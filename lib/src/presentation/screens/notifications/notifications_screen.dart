
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/widgets/av_app_bar.dart';
import 'package:flutter/material.dart';

import '../../blocs/notification/notification_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationCubit notificationCubit;

  @override
  void initState() {
    super.initState();
    notificationCubit = getItInstance<NotificationCubit>();
    notificationCubit.loadNotification();
  }

  @override
  void dispose() {
    super.dispose();
    notificationCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AVAppBar(
        elevation: true,
        title: 'Notifications',
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)
        ),
      ),
      body: Center(
        child: Text('Notifications will be available soon...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
