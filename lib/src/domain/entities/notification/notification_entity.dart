
class NotificationsEntity {
  NotificationsEntity({
    this.notifications,
  });

  final List<NotificationData>? notifications;

}

class NotificationData {
  NotificationData({
    this.id,
    this.message,
    this.timeStamp,
  });

  final int? id;
  final String? message;
  final String? timeStamp;
}
