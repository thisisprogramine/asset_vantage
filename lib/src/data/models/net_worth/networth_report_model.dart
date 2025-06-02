import 'dart:convert';
import 'dart:developer';

import '../../../domain/entities/net_worth/net_worth_entity.dart';

class NetWorthReportModel extends NetWorthReportEntity {
  NetWorthReportModel({
    this.result,
  }) : super(report: result ?? []);

  final List<ReportData>? result;

  factory NetWorthReportModel.fromJson({required Map<dynamic, dynamic> json, bool fromCache = false}) {
    List<Map<String, dynamic>> simplifiedJsonResponse = [];
    try{
      if(fromCache){
        simplifiedJsonResponse = (json["result"] as List).map((e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>)).toList();
      }else if (json["result"] != null) {
        if(json["result"]["All"] != null) {
          simplifiedJsonResponse = simplifyResponse(
            jsonChildren: json["result"]["All"]["children"],
            jsonTWR_ARR: json["result"]["All"]["twr_arr"],
            jsonVariables: json["result"]["All"]["variables"],
            title: json["result"]["All"]["title"],
          );
        }
      }
    }catch(e) {
      simplifiedJsonResponse = [];
    }
    for (var element in simplifiedJsonResponse) {
      (element["children"] as List).sort((a, b) => (b["closingValue"] as num).compareTo(a["closingValue"]),);
    }
    return NetWorthReportModel(
      result: simplifiedJsonResponse.isNotEmpty
          ? simplifiedJsonResponse.map((e) => ReportData.fromJson(e)).toList()
          : null,
    );
  }

  static List<Map<String, dynamic>> simplifyResponse({
    Map<dynamic, dynamic>? jsonVariables,
    Map<dynamic, dynamic>? jsonTWR_ARR,
    Map<dynamic, dynamic>? jsonChildren,
    String? title,
  }) {
    List<Map<String, dynamic>> jsonChild = [];

    if (jsonVariables != null) {
      if (jsonVariables["periods"] != null) {
        final child = (jsonVariables["periods"] as Map).entries.map((element) {
          Map<String, dynamic> map = {};
          map.addAll({"title": title == "-" ? "" : title, "children": []});
          final key = (element.key as String).split('_');
          map.addAll({
            "startDate": key[0],
            "endDate": key[1],
          });
          final val = element.value as Map<String, dynamic>;
          if (val['closing'] != null && val['closing']['emv'] != null) {
            map.addAll({
              "closingValue":
                  val['closing']['emv'] == "-" ? 0 : val['closing']['emv']
            });
          }
          if (val["xirr_inc"] != null) {
            map.addAll(
                {"inceptionIRR": val['xirr_inc'] == "-" ? 0 : val['xirr_inc']});
          }
          if (val["xirr"] != null) {
            map.addAll({"periodIRR": val['xirr'] == "-" ? 0 : val['xirr']});
          }
          return map;
        }).toList();
        jsonChild = child;
      }
    }
    if (jsonTWR_ARR != null) {
      if (jsonTWR_ARR["periods"] != null) {
        (jsonTWR_ARR["periods"] as Map).entries.forEach((element) {
          final key = (element.key as String).split('_');
          final indexOfEle = jsonChild.indexWhere(
            (element) =>
                element['startDate'] == key[0] && element['endDate'] == key[1],
          );
          final val = element.value as Map<String, dynamic>;
          if (val["twr"] != null) {
            jsonChild[indexOfEle]
                .addAll({"periodTWR": val['twr'] == "-" ? 0 : val['twr']});
          }
          if (val["an_twr_inc"] != null) {
            jsonChild[indexOfEle].addAll({
              "inceptionTWR": val['an_twr_inc'] == "-" ? 0 : val['an_twr_inc']
            });
          }
        });
      }
    }
    if (jsonChildren != null) {
      final childrenList = (jsonChildren as Map)
          .values
          .toList()
          .map((ele) => simplifyResponse(
              jsonChildren: ele["children"],
              jsonTWR_ARR: ele["twr_arr"],
              jsonVariables: ele["variables"],
              title: ele["title"]))
          .toList();
      childrenList.forEach((ele) {
        ele.forEach((firstLeveList) {
          final indexOfEle = jsonChild.indexWhere((child) =>
              child["startDate"] == firstLeveList["startDate"] &&
              child["endDate"] == firstLeveList["endDate"]);
          if (indexOfEle != -1) {
            (jsonChild[indexOfEle]["children"] as List).add(firstLeveList);
          }
        });
      });
    }
    return jsonChild;
  }

  Map<dynamic, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class ReportData extends ReportEntity {
  ReportData({
    this.children,
    this.closingVal,
    this.endDat,
    this.inceptionIrrPercent,
    this.inceptionTWRPercent,
    this.periodIrrPercent,
    this.periodTWRPercent,
    this.startDat,
    this.name,
  }) : super(
          title: name ?? '--',
          startDate: startDat ?? '--',
          periodTWRPercent: periodTWRPercent ?? 0.0,
          periodIrrPercent: periodIrrPercent ?? 0.0,
          inceptionTWRPercent: inceptionTWRPercent ?? 0.0,
          inceptionIrrPercent: inceptionIrrPercent ?? 0.0,
          endDate: endDat ?? '--',
          closingValue: closingVal ?? 0.0,
          children: children ?? [],
        );

  final String? startDat;
  final String? endDat;
  final double? closingVal;
  final double? periodIrrPercent;
  final double? inceptionIrrPercent;
  final double? periodTWRPercent;
  final double? inceptionTWRPercent;
  final String? name;
  final List<ReportData>? children;

  factory ReportData.fromJson(Map<dynamic, dynamic> json) => ReportData(
        closingVal: json["closingValue"] != null
            ? (json["closingValue"] is String
                ? double.parse(json["closingValue"])
                : json["closingValue"] is int
                    ? double.parse("${json["closingValue"]}")
                    : json["closingValue"])!
            : null,
        endDat: json["endDate"],
        inceptionIrrPercent: json["inceptionIRR"] != null
            ? (json["inceptionIRR"] is String
                ? double.parse(json["inceptionIRR"])
                : json["inceptionIRR"] is int
                    ? double.parse("${json["inceptionIRR"]}")
                    : json["inceptionIRR"])!
            : null,
        inceptionTWRPercent: json["inceptionTWR"] != null
            ? (json["inceptionTWR"] is String
                ? double.parse(json["inceptionTWR"])
                : json["inceptionTWR"] is int
                    ? double.parse("${json["inceptionTWR"]}")
                    : json["inceptionTWR"])!
            : null,
        periodIrrPercent: json["periodIRR"] != null
            ? (json["periodIRR"] is String
                ? double.parse(json["periodIRR"])
                : json["periodIRR"] is int
                    ? double.parse("${json["periodIRR"]}")
                    : json["periodIRR"])!
            : null,
        periodTWRPercent: json["periodTWR"] != null
            ? (json["periodTWR"] is String
                ? double.parse(json["periodTWR"])
                : json["periodTWR"] is int
                    ? double.parse("${json["periodTWR"]}")
                    : json["periodTWR"])!
            : null,
        startDat: json["startDate"],
        children:
            json["children"] != null && (json["children"] as List).isNotEmpty
                ? List<ReportData>.from(
                    json["children"]!.map((x) => ReportData.fromJson(x)))
                : [],
        name: json["title"],
      );

  Map<dynamic, dynamic> toJson() => {
        "title": name,
        "children": children != null
            ? List<dynamic>.from(children!.map((x) => x.toJson()))
            : [],
        "startDate": startDat,
        "endDate": endDat,
        "closingValue": closingVal,
        "inceptionIRR": inceptionIrrPercent,
        "periodIRR": periodIrrPercent,
        "periodTWR": periodTWRPercent,
        "inceptionTWR": inceptionTWRPercent,
      };
}
