import 'package:bloc/bloc.dart';

class PerformanceLoadingCubit extends Cubit<bool> {
  PerformanceLoadingCubit() : super(false);

  void startLoading() => emit(false);

  void endLoading() => emit(true);
}
