
import 'package:flutter/material.dart';

class AppThemeParams {
  final BuildContext context;
  final int index;

  AppThemeParams({
    required this.context,
    required this.index,
  });

  Map<String, dynamic> toJson() => {
    "index": index
  };
}