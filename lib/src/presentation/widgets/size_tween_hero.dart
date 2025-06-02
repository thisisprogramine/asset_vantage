import 'dart:developer';

import 'package:flutter/material.dart';

class SizeAwareRectTween extends RectTween {
  final Rect? source;
  final Rect? dest;

  SizeAwareRectTween({required this.source,required this.dest}):super(begin: source,end: dest);

  @override
  Rect lerp(double t) {
    final destRect = dest;
    return Rect.fromLTWH(
      destRect!.left,
      destRect.top>source!.top?(source!.top+((destRect.top-source!.top)*t)):(source!.top-((source!.top-destRect.top)*t)),
      destRect.width,
      destRect.height,
    );
  }
}