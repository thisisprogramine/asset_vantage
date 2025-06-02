
import 'dart:developer';

import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/usecases/cash_balance/get_cb_sort_filter.dart';
import '../../../../domain/usecases/cash_balance/save_cb_sort_filter.dart';

class ExpenseSortCubit extends Cubit<Sort> {
  ExpenseSortCubit() : super(Sort.descending);

  void tableSortChange(int index) async {
    emit(Sort.values[index]);
  }

}

enum Sort { az, za, ascending, descending }