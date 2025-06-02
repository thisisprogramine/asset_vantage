
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../entities/app_error.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class ClearAllTheFilters {
  final AVRepository _avRepository;

  ClearAllTheFilters(this._avRepository);

  Future<void> call() async =>
      _avRepository.clearAllTheFilters();
}
