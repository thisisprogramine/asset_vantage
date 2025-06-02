import '../../../domain/entities/dashboard/dashboard_widget_entity.dart';

class WidgetListModel extends WidgetListEntity{
  List<Data>? data;

  WidgetListModel({
    this.data
  }) : super(
    widgetData: data
  );

  factory WidgetListModel.fromJson(Map<String, dynamic> json) {
    final list = <Data>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        list.add(Data.fromJson(v));
      });
    }
    return WidgetListModel(
      data: list
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data extends WidgetData{
  final int? index;
  final String? tileName;

  Data({
    this.index,
    this.tileName,
  }) : super(
      index: index,
    tileName: tileName,
  );

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      index: json['index'] != null ? json['index']! : null,
      tileName: json['tileName'] != null ? json['tileName']! : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index != null ? index! : null,
      'tileName': tileName != null ? tileName! : null,
    };
  }

}