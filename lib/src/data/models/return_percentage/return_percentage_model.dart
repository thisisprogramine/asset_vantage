
import '../../../domain/entities/return_percentage/return_percentage_entity.dart';

enum ReturnType {MTD, QTD, CYTD, FYTD, Yr1, Yr2, Yr3, IncTwr, IncIrr}
class ReturnPercentModel extends ReturnPercentEntity {
  ReturnPercentModel({
    this.allReturnPercentList,
  }) : super(returnPercentList: allReturnPercentList ?? []);

  final List<ReturnPercentItem>? allReturnPercentList;

  factory ReturnPercentModel.fromJson(Map<dynamic, dynamic> json) {
    return ReturnPercentModel(
        allReturnPercentList: json["result"] == null
            ? []
            : List<ReturnPercentItem>.from(
            json["result"]!.map((x) => ReturnPercentItem.fromJson(x))));
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "result": returnPercentList == null
          ? []
          : List<Map<dynamic, dynamic>>.from(
          returnPercentList!.map((x) => x?.toJson())),
    };
  }
}

ReturnType _getReturnType({required String id}) {
  switch(id) {
    case 'mtd_twr':
      return ReturnType.MTD;
    case 'qtd_twr':
      return ReturnType.QTD;
    case 'cytd_twr':
      return ReturnType.CYTD;
    case 'fytd_twr':
      return ReturnType.FYTD;
    case 'year_1_twr':
      return ReturnType.Yr1;
    case 'year_2_twr':
      return ReturnType.Yr2;
    case 'year_3_twr':
      return ReturnType.Yr3;
    case 'twr':
      return ReturnType.IncTwr;
    case 'xirr':
      return ReturnType.IncIrr;
    default:
      return ReturnType.MTD;
  }
}

String setReturnType({required ReturnType type}) {
  switch(type) {
    case ReturnType.MTD:
      return 'MTD';
    case ReturnType.QTD:
      return 'QTD';
    case ReturnType.CYTD:
      return 'CYTD';
    case ReturnType.FYTD:
      return 'FYTD';
    case ReturnType.Yr1:
      return 'year_1';
    case ReturnType.Yr2:
      return 'year_2';
    case ReturnType.Yr3:
      return 'year_3';
    case ReturnType.IncTwr:
      return 'xirr';
    case ReturnType.IncIrr:
      return 'xirr';
    default:
      return 'MTD';
  }
}

class ReturnPercentItem extends ReturnPercentItemData {
  const ReturnPercentItem({
    this.id,
    required this.value,
    this.key,
    this.name,
  }) : super(id: id, value: value, key: key, name: name);

  final String? id;
  final ReturnType value;
  final String? key;
  final String? name;

  factory ReturnPercentItem.fromJson(Map<dynamic, dynamic> json) {
    return ReturnPercentItem(
      id: json["id"],
      value: _getReturnType(id: json["id"] ?? ''),
      key: json["key"],
      name: json["name"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "value": setReturnType(type: value),
    "key": key,
    "name": name,
  };
}
