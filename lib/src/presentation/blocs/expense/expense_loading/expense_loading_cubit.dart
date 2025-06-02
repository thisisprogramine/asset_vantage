import 'package:bloc/bloc.dart';

class ExpenseLoadingCubit extends Cubit<bool> {
  ExpenseLoadingCubit() : super(false);

  void startLoading() => emit(false);

  void endLoading() => emit(true);
}
