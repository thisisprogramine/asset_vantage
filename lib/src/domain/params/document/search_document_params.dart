import 'package:flutter/material.dart';

class SearchDocumentParams{
  final BuildContext context;
  final String entity;
  final String id;
  final String entitytype;
  final String? searchstring;
  final String limit;
  final String startfrom;
  const SearchDocumentParams({
    required this.context,
    required this.entity,
    required this.id,
    required this.entitytype,
    this.searchstring,
    required this.limit,
    required this.startfrom,
  });

  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      'id': id,
      'entitytype': entitytype,
      'searchstring': searchstring,
      'limit': limit,
      'startfrom': startfrom,
    };
  }
}