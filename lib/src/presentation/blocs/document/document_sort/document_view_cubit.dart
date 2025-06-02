
import 'package:flutter_bloc/flutter_bloc.dart';


class DocumentSortCubit extends Cubit<Sort> {
  DocumentSortCubit() : super(Sort.az);

  void documentSortChange(Sort view) async{
    emit(view);
  }
}

enum Sort {az, za, latest, oldest}