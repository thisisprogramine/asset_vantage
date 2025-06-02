
import '../../../domain/entities/notification/notification_entity.dart';

class NotificationsModel extends NotificationsEntity{
  NotificationsModel({
    this.result,
  }) : super(
    notifications: result
  );

  final List<Notification>? result;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    final keyList = json.keys.toList();
    final List<Notification> list = [];


    keyList.forEach((element) {
      list.add(Notification.fromJson(json[element]));
    });

    return NotificationsModel(
        result: list
    );
  }

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Notification extends NotificationData{
  Notification({
    this.id,
    this.message,
    this.timeStamp,
  }) : super(
    id: id,
    message: message,
    timeStamp: timeStamp
  );

  final int? id;
  final String? message;
  final String? timeStamp;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    message: json["Message"],
    timeStamp: json["TimeStamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Message": message,
    "TimeStamp": timeStamp,
  };
}
