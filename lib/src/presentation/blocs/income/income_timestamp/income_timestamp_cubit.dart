

import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeTimestampCubit extends Cubit<String?> {

  IncomeTimestampCubit() : super(null);

  void updateIncomeTimestamp({required String? timeStamp}) async{

    emit(timeStamp);
    emit(timeStamp);
  }

}
