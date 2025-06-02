
import 'dart:developer';

import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/usecases/cash_balance/get_cb_sort_filter.dart';
import '../../../../domain/usecases/cash_balance/save_cb_sort_filter.dart';

class CashBalanceSortCubit extends Cubit<Sort> {
  final GetCBSortFilter cbSortFilter;
  final SaveCBSortFilter saveCBSOrtFilter;
  CashBalanceSortCubit({
    required this.saveCBSOrtFilter,
    required this.cbSortFilter,
  }) : super(Sort.descending);

  void tableSortChange(int index) async {
    await saveSelectedOne(index: index);
    emit(Sort.values[index]);
  }

  Future<int?> getSelectedOne() async {
    final Either<AppError, int?> eitherSort = await cbSortFilter(NoParams());

    return eitherSort.fold((l) {
      log(l.message);
      return null;
    }, (r) => r);
  }

  Future<void> saveSelectedOne({required int index}) async {
    final Either<AppError, void> eitherSort = await saveCBSOrtFilter(index);

    return eitherSort.fold((l) => log(l.message), (r) => log('filter saved'));
  }
}

enum Sort { az, za, ascending, descending }