import 'package:bloc/bloc.dart';

class NetWorthLoadingCubit extends Cubit<bool> {
  NetWorthLoadingCubit() : super(false);

  void startLoading() => emit(false);

  void endLoading() => emit(true);
}
