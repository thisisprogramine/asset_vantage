import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


part 'dashboard_datepicker_state.dart';

class DashboardDatePickerCubit extends Cubit<DashboardDatePickerState> {

  DashboardDatePickerCubit() : super(DashboardDateInitial(
    date: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1))),
  ));

  Future<void> changeAsOnDate({String? asOnDate}) async{
    emit(DashboardDateInitial(
      date: state.asOnDate,
    ));

    emit(DashboardDateChanged(
      date: asOnDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1))),
    ));
  }
}