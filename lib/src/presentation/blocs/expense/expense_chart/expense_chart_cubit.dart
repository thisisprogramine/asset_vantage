import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseChartCubit extends Cubit<int> {

  ExpenseChartCubit() : super(11);

  void changeSelectedIndex({required int? selectedIndex, required int? selectedNumberOfPeriod}) async{
    if((selectedIndex ?? 0) <= ((selectedNumberOfPeriod) ?? 0) - 1) {
      emit(selectedIndex ?? 0);
    }else {
      emit((selectedNumberOfPeriod ?? 0) - 1);
    }
  }
}
