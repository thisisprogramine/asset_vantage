
import 'package:flutter/services.dart';

import '../../../domain/entities/document/download_entity.dart';

class DownloadData extends DownloadEntity{
  Uint8List file;
  String name;
  String extension;
  String type;

  DownloadData({
    required this.file,
    required this.name,
    required this.extension,
    required this.type,
  }) : super(
    file: file,
    name: name,
    extension: extension,
    type: type,
  );
}