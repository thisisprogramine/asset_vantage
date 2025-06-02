import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivityCubit extends Cubit<bool> {
  InternetConnectivityCubit() : super(true);

  void establishInternetConnectivityStream() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile) {
        emit(true);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        emit(true);
      }else if (connectivityResult == ConnectivityResult.none) {
        emit(false);
      }
    });
  }
}
