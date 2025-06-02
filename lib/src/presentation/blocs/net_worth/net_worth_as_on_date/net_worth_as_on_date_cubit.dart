import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/usecases/net_worth/net_worth_filter/selected_as_on_date/get_new_worth_selected_as_on_date.dart';



part 'net_worth_as_on_date_state.dart';

class NetWorthAsOnDateCubit extends Cubit<NetWorthAsOnDateState> {
  final GetNetWorthSelectedAsOnDate getNetWorthSelectedAsOnDate;

  NetWorthAsOnDateCubit({
    required this.getNetWorthSelectedAsOnDate,
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
}