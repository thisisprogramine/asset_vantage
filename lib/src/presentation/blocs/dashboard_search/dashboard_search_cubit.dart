
import 'package:asset_vantage/src/domain/usecases/dashboard/get_dashboard_widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/dashboard/dashboard_widget_entity.dart';
import '../../../domain/params/no_params.dart';
import '../loading/loading_cubit.dart';

part 'dashboard_search_state.dart';

class DashboardSearchCubit extends Cubit<DashboardSearchState> {
  final LoadingCubit loadingCubit;
  final GetDashboardWidgetData getDashboardWidgetData;

  DashboardSearchCubit({
    required this.loadingCubit,
    required this.getDashboardWidgetData,
  }) : super(const DashboardSearchInitial());

  void searchDashboardWidget({required BuildContext context, required String query}) async{
    loadingCubit.show();

    emit(const DashboardSearchInitial());

    final Either<AppError, WidgetListEntity> eiterDashboardWidget = await getDashboardWidgetData(context);

    eiterDashboardWidget.fold((error) {
      emit(const DashboardSearchLoaded([]));
    }, (widget) {

      if(widget.widgetData != null && (widget.widgetData?.isNotEmpty ?? false) && query.isNotEmpty) {

      }else {
        emit(const DashboardSearchLoaded([]));
      }



    });

    loadingCubit.hide();
  }


}
