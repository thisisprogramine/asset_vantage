

import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseTimestampCubit extends Cubit<String?> {

  ExpenseTimestampCubit() : super(null);

  void updateExpenseTimestamp({required String? timeStamp}) async{

    emit(timeStamp);
    emit(timeStamp);
  }

}
