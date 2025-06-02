
import 'package:flutter_bloc/flutter_bloc.dart';


class DocumentViewCubit extends Cubit<ViewType> {
  DocumentViewCubit() : super(ViewType.initial);

  void documentViewChange(ViewType view) async{
    emit(view);
  }
}

enum ViewType {list, grid,initial}