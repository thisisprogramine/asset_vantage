import 'package:flutter/material.dart';

class DownloadParams{
  final BuildContext context;
  final String documentId;
  final String name;
  final String extension;
  final String type;

  const DownloadParams({
    required this.context,
    required this.documentId,
    required this.name,
    required this.extension,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'name': name,
      'extension': extension,
      'type': type,
    };
  }
}