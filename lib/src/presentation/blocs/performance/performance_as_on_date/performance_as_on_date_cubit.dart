import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/usecases/performance/performance_filter/selected_as_on_date/get_performance_selected_as_on_date.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_as_on_date/save_performance_selected_as_on_date.dart';


part 'performance_as_on_date_state.dart';

class PerformanceAsOnDateCubit extends Cubit<PerformanceAsOnDateState> {
  final GetPerformanceSelectedAsOnDate getPerformanceSelectedAsOnDate;
  final SavePerformanceSelectedAsOnDate savePerformanceSelectedAsOnDate;

  PerformanceAsOnDateCubit({
    required this.getPerformanceSelectedAsOnDate,
    required this.savePerformanceSelectedAsOnDate,
  }) : super(AsOnDateInitial(
    date: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1))),
  ));

  Future<void> changeAsOnDate({String? asOnDate}) async{
    emit(AsOnDateInitial(
      date: state.asOnDate,
    ));

    emit(AsOnDateChanged(
      date: asOnDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1))),
    ));
  }

  Future<void> changeAsOnDateNew({String? asOnDate}) async {
    final String newDate = asOnDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));

    print("Fev item: changeAsOnDate called with date: $newDate");

    emit(AsOnDateInitial(date: state.asOnDate));
    print("Fev item: Emitted AsOnDateInitial with previous date: ${state.asOnDate}");

    emit(AsOnDateChanged(date: newDate));
    print("Fev item: Emitted AsOnDateChanged with new date: $newDate");
  }
}