import 'package:bloc/bloc.dart';

class CashBalanceLoadingCubit extends Cubit<bool> {
  CashBalanceLoadingCubit() : super(false);

  void startLoading() => emit(false);

  void endLoading() => emit(true);
}
