class WidgetListEntity {
  List<WidgetData>? widgetData;

  WidgetListEntity({this.widgetData});
}

class WidgetData {
  final int? index;
  final String? tileName;

  WidgetData({this.index, this.tileName,});
}