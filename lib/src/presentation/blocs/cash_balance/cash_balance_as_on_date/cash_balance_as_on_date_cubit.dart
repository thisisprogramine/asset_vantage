import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_as_on_date/get_cash_balance_selected_as_on_date.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_as_on_date/save_cash_balance_selected_as_on_date.dart';



part 'cash_balance_as_on_date_state.dart';

class CashBalanceAsOnDateCubit extends Cubit<CashBalanceAsOnDateState> {
  final GetCashBalanceSelectedAsOnDate getCashBalanceSelectedAsOnDate;
  final SaveCashBalanceSelectedAsOnDate saveCashBalanceSelectedAsOnDate;

  CashBalanceAsOnDateCubit({
    required this.getCashBalanceSelectedAsOnDate,
    required this.saveCashBalanceSelectedAsOnDate,
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