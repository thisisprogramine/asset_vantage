
import 'package:asset_vantage/src/domain/entities/performance/performance_report_entity.dart';

class PerformanceReportModel extends PerformanceReportEntity{
  PerformanceReportModel({
    this.positionsList,
    this.json,
    this.title,
    this.marketValue,
    this.twrMTD,
    this.twrQTD,
    this.twrCYTD,
    this.twrFYTD,
    this.twr1YR,
    this.twr2YR,
    this.twr3YR,
    this.inceptionTWR,
    this.inceptionIRR,
    this.benchmark,
    this.benchmarkMTD,
    this.benchmarkQTD,
    this.benchmarkCYTD,
    this.benchmarkFYTD,
    this.benchmark1YR,
    this.benchmark2YR,
    this.benchmark3YR,
    this.benchmarkTWR,
    this.benchmarkIRR,
  }) : super(
    positions: positionsList ?? [],
    marketValue: marketValue,
    title: title,
    twrMTD: twrMTD,
    twrQTD: twrQTD,
    twrCYTD: twrCYTD,
    twrFYTD: twrFYTD,
    twr1YR: twr1YR,
    twr2YR: twr2YR,
    twr3YR: twr3YR,
    inceptionTWR: inceptionTWR,
    inceptionIRR: inceptionIRR,
    benchmarkMTD: benchmarkMTD,
    benchmarkQTD: benchmarkQTD,
    benchmarkCYTD: benchmarkCYTD,
    benchmarkFYTD: benchmarkFYTD,
    benchmark1YR: benchmark1YR,
    benchmarkTWR: benchmarkTWR,
    benchmarkIRR: benchmarkIRR,
  );

  final List<PerformanceReportModel>? positionsList;
  final Map<dynamic, dynamic>? json;
  final String? title;
  final double? marketValue;
  final double? twrMTD;
  final double? twrQTD;
  final double? twrCYTD;
  final double? twrFYTD;
  final double? twr1YR;
  final double? twr2YR;
  final double? twr3YR;
  final double? inceptionTWR;
  final double? inceptionIRR;
  final String? benchmark;
  final double? benchmarkMTD;
  final double? benchmarkQTD;
  final double? benchmarkCYTD;
  final double? benchmarkFYTD;
  final double? benchmark1YR;
  final double? benchmark2YR;
  final double? benchmark3YR;
  final double? benchmarkTWR;
  final double? benchmarkIRR;

  factory PerformanceReportModel.fromJson(Map<dynamic, dynamic> json) {
    List<dynamic> childrenKeys = [];
    Map<dynamic, dynamic>? children = json['children'];
    List<PerformanceReportModel> performanceList = [];

    if(children != null) {
      childrenKeys.addAll(children.keys);
    }

    for (var childKey in childrenKeys) {
      Map<dynamic, dynamic>? child = children?[childKey];
      if(child != null) {
        performanceList.add(PerformanceReportModel.fromJson(child));
      }
    }

    double? twrMTD = 0.000000;
    double? twrQTD = 0.000000;
    double? twrCYTD = 0.000000;
    double? twrFYTD = 0.000000;
    double? twr1YR = 0.000000;
    double? twr2YR = 0.000000;
    double? twr3YR = 0.000000;
    double? inceptionTWR = 0.000000;
    double? inceptionIRR = 0.000000;

    double? benchmarkMTD = 0.000000;
    double? benchmarkQTD = 0.000000;
    double? benchmarkCYTD = 0.000000;
    double? benchmarkFYTD = 0.000000;
    double? benchmark1YR = 0.000000;
    double? benchmark2YR = 0.000000;
    double? benchmark3YR = 0.000000;
    double? benchmarkTWR = 0.000000;
    double? benchmarkIRR = 0.000000;

    if(json['twr_arr'] != null) {
      Map<dynamic, dynamic> twr = json['twr_arr'];
      twrMTD = twr['mtd_twr'] != null ? double.tryParse('${twr['mtd_twr']}') : 0.000000;
      twrQTD = twr['qtd_twr'] != null ? double.tryParse('${twr['qtd_twr']}') : 0.000000;
      twrCYTD = twr['cytd_twr'] != null ? double.tryParse('${twr['cytd_twr']}') : 0.000000;
      twrFYTD = twr['fytd_twr'] != null ? double.tryParse('${twr['fytd_twr']}') : 0.000000;
      twr1YR = twr['year_1_twr'] != null ? double.tryParse('${twr['year_1_twr']}') : 0.000000;
      twr2YR = twr['year_2_annualized_twr'] != null ? double.tryParse('${twr['year_2_annualized_twr']}') : 0.000000;
      twr3YR = twr['year_3_annualized_twr'] != null ? double.tryParse('${twr['year_3_annualized_twr']}') : 0.000000;
      inceptionTWR = twr['annualized_twr'] != null ? double.tryParse('${twr['annualized_twr']}') : 0.000000;
      inceptionIRR = json['xirr'] != null ? double.tryParse('${json['xirr']}') : 0.000000;
    }else{
      inceptionIRR = json['xirr'] != null ? double.tryParse('${json['xirr']}') : 0.000000;
    }

    if(json['benchmark'] != null) {
      Map<dynamic, dynamic> benchmark = json['benchmark'];
      benchmarkMTD = benchmark['mtd_twr'] != null ? double.tryParse('${benchmark['mtd_twr']}') : 0.000000;
      benchmarkQTD = benchmark['qtd_twr'] != null ? double.tryParse('${benchmark['qtd_twr']}') : 0.000000;
      benchmarkCYTD = benchmark['cytd_twr'] != null ? double.tryParse('${benchmark['cytd_twr']}') : 0.000000;
      benchmarkFYTD = benchmark['fytd_twr'] != null ? double.tryParse('${benchmark['fytd_twr']}') : 0.000000;
      benchmark1YR = benchmark['year_1_twr'] != null ? double.tryParse('${benchmark['year_1_twr']}') : 0.000000;
      benchmark2YR = benchmark['year_2_annualized_twr'] != null ? double.tryParse('${benchmark['year_2_annualized_twr']}') : 0.000000;
      benchmark3YR = benchmark['year_3_annualized_twr'] != null ? double.tryParse('${benchmark['year_3_annualized_twr']}') : 0.000000;
      benchmarkTWR = benchmark['annualized_twr'] != null ? double.tryParse('${benchmark['annualized_twr']}') : 0.000000;
    }

    return PerformanceReportModel(
      positionsList: performanceList,
      json: json,
      title: json['title'],
      marketValue: json['value_on_date'] != null ? double.tryParse('${json['value_on_date']}'): 0.000000,
      twrMTD: twrMTD,
      twrQTD: twrQTD,
      twrCYTD: twrCYTD,
      twrFYTD: twrFYTD,
      twr1YR: twr1YR,
      twr2YR: twr2YR,
      twr3YR: twr3YR,
      inceptionTWR: inceptionTWR,
      inceptionIRR: inceptionIRR,
      benchmark: json['benchmarkname'],
      benchmarkMTD: benchmarkMTD,
      benchmarkQTD: benchmarkQTD,
      benchmarkCYTD: benchmarkCYTD,
      benchmarkFYTD: benchmarkFYTD,
      benchmark1YR: benchmark1YR,
      benchmark2YR: benchmark2YR,
      benchmark3YR: benchmark3YR,
      benchmarkTWR: benchmarkTWR,
      benchmarkIRR: benchmarkIRR,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return json ?? {};
  }
}
