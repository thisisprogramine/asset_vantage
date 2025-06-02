import 'package:bloc/bloc.dart';

class StealthCubit extends Cubit<bool> {
  StealthCubit() : super(false);

  void show() => emit(true);

  void hide() => emit(false);
}
