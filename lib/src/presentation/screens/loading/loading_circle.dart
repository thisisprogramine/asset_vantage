import 'package:flutter/material.dart';

import '../../widgets/circular_progress.dart';

class LoadingCircle extends StatelessWidget {
  final double size;

  const LoadingCircle({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressWidget();
  }
}
