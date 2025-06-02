import 'package:flutter/services.dart';

class DownloadEntity{
  Uint8List file;
  String name;
  String extension;
  String type;

  DownloadEntity({
    required this.file,
    required this.name,
    required this.extension,
    required this.type,
  });
}