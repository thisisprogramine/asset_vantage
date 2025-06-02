import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';



part 'favourite_universal_filter_as_on_date_state.dart';

class FavouriteUniversalFilterAsOnDateCubit extends Cubit<FavouriteUniversalFilterAsOnDateState> {

  FavouriteUniversalFilterAsOnDateCubit(

  ) : super(AsOnDateInitial(
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

    emit(AsOnDateInitial(date: state.asOnDate));

    emit(AsOnDateChanged(date: newDate));
  }
}