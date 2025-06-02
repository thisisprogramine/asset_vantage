import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../config/constants/hive_constants.dart';

class PerformanceSortCubit extends Cubit<Sort> {
  late final Box _preferencesBox;

  PerformanceSortCubit() : super(Sort.descending);

  void tableSortChange(int index) async {
    final newSort = Sort.values[index];
    emit(newSort);
    await _saveSortPreference(newSort);
  }

  Future<void> _saveSortPreference(Sort sort) async {
    if (_preferencesBox.isOpen) {
      await _preferencesBox.put(HiveFields.performanceSortReport, sort.index);
    }
  }

  void _loadSortPreference() {
    if (_preferencesBox.isOpen) {
      final sortIndex = _preferencesBox.get(
        HiveFields.performanceSortReport,
        defaultValue: Sort.descending.index,
      );
      emit(Sort.values[sortIndex]);
    }
  }
}

enum Sort { az, za, ascending, descending }
