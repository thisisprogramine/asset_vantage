//


class AppThemeModel {
  final String? brandLogo;
  String? brandName;
  final String? textColor;
  final String? scaffoldBackground;
  final String? loadingIndicatorColor;
  final String? buttonColor;
  final AppBar? appBar;
  final ToolBarTheme? toolBar;
  final PopupMenu? popupMenu;
  final Card? card;
  final Filter? filter;
  final BottomSheet? bottomSheet;
  final Dashboard? dashboard;
  final NavigationDrawer? navigationDrawer;
  final Grouping? grouping;
  final IpsChart? ipsChart;
  final CashBalanceTable? cashBalanceTable;
  final NetWorthChar? netWorthChar;
  final PerformanceChart? performanceChart;
  final SearchBar? searchBar;
  final Document? document;

  AppThemeModel({
    this.brandLogo,
    this.brandName,
    this.textColor,
    this.scaffoldBackground,
    this.loadingIndicatorColor,
    this.buttonColor,
    this.appBar,
    this.toolBar,
    this.popupMenu,
    this.card,
    this.filter,
    this.bottomSheet,
    this.dashboard,
    this.navigationDrawer,
    this.grouping,
    this.ipsChart,
    this.cashBalanceTable,
    this.netWorthChar,
    this.performanceChart,
    this.searchBar,
    this.document,
  });

  factory AppThemeModel.fromJson(Map<dynamic, dynamic> json) => AppThemeModel(
    brandLogo: json["brandLogo"],
    brandName: json["brandName"],
    textColor: json["textColor"],
    scaffoldBackground: json["backgroundColor"],
    loadingIndicatorColor: json["primaryColor"],
    buttonColor: json["secondaryColor"],
    appBar: AppBar.fromJson(json),
    toolBar: ToolBarTheme.fromJson(json),
    popupMenu: PopupMenu.fromJson(json),
    card: Card.fromJson(json),
    filter: Filter.fromJson(json),
    bottomSheet: BottomSheet.fromJson(json),
    dashboard: Dashboard.fromJson(json),
    navigationDrawer: NavigationDrawer.fromJson(json),
    grouping: Grouping.fromJson(json),
    ipsChart: IpsChart.fromJson(json),
    cashBalanceTable: CashBalanceTable.fromJson(json),
    netWorthChar: NetWorthChar.fromJson(json),
    performanceChart: PerformanceChart.fromJson(json),
    searchBar: SearchBar.fromJson(json),
    document: Document.fromJson(json),
  );

  Map<String, dynamic> toJson() => {
    "brandLogo": brandLogo,
    "brandName": brandName,
    "textColor": textColor,
    "scaffoldBackground": scaffoldBackground,
    "loadingIndicatorColor": loadingIndicatorColor,
    "buttonColor": buttonColor,
    "appBar": appBar?.toJson(),
    "toolBar": toolBar?.toJson(),
    "popupMenu": popupMenu?.toJson(),
    "card": card?.toJson(),
    "filter": filter?.toJson(),
    "bottomSheet": bottomSheet?.toJson(),
    "dashboard": dashboard?.toJson(),
    "navigationDrawer": navigationDrawer?.toJson(),
    "grouping": grouping?.toJson(),
    "ipsChart": ipsChart?.toJson(),
    "cashBalanceTable": cashBalanceTable?.toJson(),
    "netWorthChar": netWorthChar?.toJson(),
    "performanceChart": performanceChart?.toJson(),
    "searchBar": searchBar?.toJson(),
    "document": document?.toJson(),
  };
}

class AppBar {
  final String? iconColor;
  final String? color;
  final String? backArrowColor;

  AppBar({
    this.iconColor,
    this.color,
    this.backArrowColor,
  });

  factory AppBar.fromJson(Map<dynamic, dynamic> json) => AppBar(
    iconColor: json["iconColor"],
    color: json["backgroundColor"],
    backArrowColor: json["iconColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "iconColor": iconColor,
    "color": color,
    "backArrowColor": backArrowColor,
  };
}

class BottomSheet {
  final String? color;
  final String? backArrowColor;
  final String? borderColor;
  final String? checkColor;

  BottomSheet({
    this.color,
    this.backArrowColor,
    this.borderColor,
    this.checkColor,
  });

  factory BottomSheet.fromJson(Map<dynamic, dynamic> json) => BottomSheet(
    color: json["backgroundColor"],
    backArrowColor: json["primaryColor"],
    borderColor: json["borderColor"],
    checkColor: json["primaryColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "color": color,
    "backArrowColor": backArrowColor,
    "borderColor": borderColor,
    "checkColor": checkColor,
  };
}

class CashBalanceTable {
  final String? borderColor;

  CashBalanceTable({
    this.borderColor,
  });

  factory CashBalanceTable.fromJson(Map<dynamic, dynamic> json) => CashBalanceTable(
    borderColor: json["borderColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "borderColor": borderColor,
  };
}

class Dashboard {
  final String? borderColor;
  final String? iconColor;
  final String? iconBackgroundColor;

  Dashboard({
    this.borderColor,
    this.iconColor,
    this.iconBackgroundColor,
  });

  factory Dashboard.fromJson(Map<dynamic, dynamic> json) => Dashboard(
    borderColor: json["iconColor"],
    iconColor: json["primaryColor"],
    iconBackgroundColor: json["cardColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "borderColor": borderColor,
    "iconColor": iconColor,
    "iconBackgroundColor": iconBackgroundColor,
  };
}

class Document {
  final String? iconColor;

  Document({
    this.iconColor,
  });

  factory Document.fromJson(Map<dynamic, dynamic> json) => Document(
    iconColor: json["primaryColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "iconColor": iconColor,
  };
}

class ToolBarTheme {
  final String? iconColor;

  ToolBarTheme({
    this.iconColor,
  });

  factory ToolBarTheme.fromJson(Map<dynamic, dynamic> json) => ToolBarTheme(
    iconColor: json["iconColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "iconColor": iconColor,
  };
}

class Filter {
  final String? color;
  final String? iconColor;

  Filter({
    this.color,
    this.iconColor,
  });

  factory Filter.fromJson(Map<dynamic, dynamic> json) => Filter(
    color: json["color"],
    iconColor: json["primaryColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "color": color,
    "iconColor": iconColor,
  };
}

class SearchBar {
  final String? color;
  final String? iconColor;

  SearchBar({
    this.color,
    this.iconColor,
  });

  factory SearchBar.fromJson(Map<dynamic, dynamic> json) => SearchBar(
    color: json["color"],
    iconColor: json["iconColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "color": color,
    "iconColor": iconColor,
  };
}

class NavigationDrawer {
  final String? color;
  final String? iconColor;

  NavigationDrawer({
    this.color,
    this.iconColor,
  });

  factory NavigationDrawer.fromJson(Map<dynamic, dynamic> json) => NavigationDrawer(
    color: json["backgroundColor"],
    iconColor: json["primaryColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "color": color,
    "iconColor": iconColor,
  };
}

class Grouping {
  final String? borderColor;
  final String? iconClor;

  Grouping({
    this.borderColor,
    this.iconClor,
  });

  factory Grouping.fromJson(Map<dynamic, dynamic> json) => Grouping(
    borderColor: json["iconColor"],
    iconClor: json["primaryColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "borderColor": borderColor,
    "iconClor": iconClor,
  };
}

class IpsChart {
  final String? bgColor;
  final String? color;
  final String? borderColor;
  final String? targetColor;
  final String? actualColor;
  final String? returnColor;
  final String? benchMarkColor;

  IpsChart({
    this.bgColor,
    this.color,
    this.borderColor,
    this.targetColor,
    this.actualColor,
    this.returnColor,
    this.benchMarkColor,
  });

  factory IpsChart.fromJson(Map<dynamic, dynamic> json) => IpsChart(
    bgColor: json["bgColor"],
    color: json["color"],
    borderColor: json["borderColor"],
    targetColor: json["targetColor"],
    actualColor: json["actualColor"],
    returnColor: json["returnColor"],
    benchMarkColor: json["benchMarkColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "bgColor": bgColor,
    "color": color,
    "borderColor": borderColor,
    "targetColor": targetColor,
    "actualColor": actualColor,
    "returnColor": returnColor,
    "benchMarkColor": benchMarkColor,
  };
}

class NetWorthChar {
  final String? periodBorderColor;
  final String? chartColor1;
  final String? chartColor2;
  final String? chartBorderColor;

  NetWorthChar({
    this.periodBorderColor,
    this.chartColor1,
    this.chartColor2,
    this.chartBorderColor,
  });

  factory NetWorthChar.fromJson(Map<dynamic, dynamic> json) => NetWorthChar(
    periodBorderColor: json["periodBorderColor"],
    chartColor1: json["chartColor1"],
    chartColor2: json["chartColor2"],
    chartBorderColor: json["chartBorderColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "periodBorderColor": periodBorderColor,
    "chartColor1": chartColor1,
    "chartColor2": chartColor2,
    "chartBorderColor": chartBorderColor,
  };
}

class PerformanceChart {
  final String? marketValueColor;
  final String? returnColorPositive;
  final String? returnColorNegative;

  PerformanceChart({
    this.marketValueColor,
    this.returnColorPositive,
    this.returnColorNegative,
  });

  factory PerformanceChart.fromJson(Map<dynamic, dynamic> json) => PerformanceChart(
    marketValueColor: json["marketValueColor"],
    returnColorPositive: json["returnColorPositive"],
    returnColorNegative: json["returnColorNegative"],
  );

  Map<dynamic, dynamic> toJson() => {
    "marketValueColor": marketValueColor,
    "returnColorPositive": returnColorPositive,
    "returnColorNegative": returnColorNegative,
  };
}

class PopupMenu {
  final String? color;

  PopupMenu({
    this.color,
  });

  factory PopupMenu.fromJson(Map<dynamic, dynamic> json) => PopupMenu(
    color: json["cardColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "color": color,
  };
}

class Card {
  final String? color;

  Card({
    this.color,
  });

  factory Card.fromJson(Map<dynamic, dynamic> json) => Card(
    color: json["cardColor"],
  );

  Map<dynamic, dynamic> toJson() => {
    "color": color,
  };
}

