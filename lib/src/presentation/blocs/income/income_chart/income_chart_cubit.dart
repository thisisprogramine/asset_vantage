
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/income/income_chart_data.dart';
import '../../../../domain/entities/income_expense/income_expense_number_of_period_entity.dart';
import '../../../../domain/params/income/income_expense_save_filter_params.dart';
import '../../../../domain/usecases/income_expense/save_income_expense_period.dart';

class IncomeChartCubit extends Cubit<int> {

  IncomeChartCubit() : super(11);

  void changeSelectedIndex({required int? selectedIndex, required int? selectedNumberOfPeriod}) async{
    if((selectedIndex ?? 0) <= ((selectedNumberOfPeriod) ?? 0) - 1) {
      emit(selectedIndex ?? 0);
    }else {
      emit((selectedNumberOfPeriod ?? 0) - 1);
    }
  }
}
