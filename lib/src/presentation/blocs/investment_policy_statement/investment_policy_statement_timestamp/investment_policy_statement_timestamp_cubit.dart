

import 'package:flutter_bloc/flutter_bloc.dart';

class InvestmentPolicyStatementTimestampCubit extends Cubit<String?> {

  InvestmentPolicyStatementTimestampCubit() : super(null);

  void updateIPSTimestamp({required String? timeStamp}) async{

    emit(timeStamp);
    emit(timeStamp);
  }

}
