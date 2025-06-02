import 'package:bloc/bloc.dart';

class IncomeLoadingCubit extends Cubit<bool> {
  IncomeLoadingCubit() : super(false);

  void startLoading() => emit(false);

  void endLoading() => emit(true);
}
