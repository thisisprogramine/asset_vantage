
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/dashboard/dashboard_widget_entity.dart';
import '../../../domain/params/dashboard/dashboard_seq_params.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/dashboard/get_dashboard_widgets.dart';
import '../../../domain/usecases/dashboard/save_dashboard_widget_sequence.dart';
import '../loading/loading_cubit.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final LoadingCubit loadingCubit;
  final GetDashboardWidgetData getDashboardWidgetData;
  final SaveDashboardWidgetSequence saveDashboardSequence;

  DashboardCubit({
    required this.loadingCubit,
    required this.getDashboardWidgetData,
    required this.saveDashboardSequence,
  }) : super(const DashboardInitial());

  void loadDashboard({required BuildContext context}) async{
    loadingCubit.show();

    emit(const DashboardInitial());

    final Either<AppError, WidgetListEntity> eiterDashboardWidget = await getDashboardWidgetData(context);

    eiterDashboardWidget.fold((error) {

    }, (widget) {

      emit(DashboardLoaded(widgetList: widget.widgetData));

    });

    loadingCubit.hide();
  }

  void saveDashSeq({required BuildContext context, required List<int> seq}) async {
    final Either<AppError, void> eiterDashboardWidgetSequence = await saveDashboardSequence(DashboardSeqParams(context: context, seq: seq));

    eiterDashboardWidgetSequence.fold((error) {
      log('${error.appErrorType}');
    }, (widget) {
      log('sequence saved');
    });
  }


}
