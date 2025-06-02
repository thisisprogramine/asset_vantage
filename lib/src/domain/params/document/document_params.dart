import 'package:flutter/cupertino.dart';

class DocumentParams{
  final BuildContext context;
  final String? entity;
  final String? entitytype;
  final String? id;
  final String limit;
  final String startfrom;
  const DocumentParams({
    required this.context,
    required this.entity,
    required this.entitytype,
    required this.id,
    required this.limit,
    required this.startfrom,
  });

  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      "entitytype": entitytype,
      "id": id,
      'limit': limit,
      'startfrom': '1970-01-01'
    };
  }
}