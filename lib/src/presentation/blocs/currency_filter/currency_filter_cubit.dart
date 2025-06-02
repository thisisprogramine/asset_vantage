

import 'dart:developer';

import 'package:asset_vantage/src/domain/entities/currency/currency_entity.dart';
import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/params/currency/get_selected_currency_params.dart';
import 'package:asset_vantage/src/domain/params/currency/save_selected_currency_params.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/currency/currency_model.dart';
import '../../../domain/entities/app_error.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/currency/getCurrency.dart';
import '../../../domain/usecases/currency/get_selected_currency.dart';
import '../../../domain/usecases/currency/save_selected_currency.dart';

part 'currency_filter_state.dart';

class CurrencyFilterCubit extends Cubit<CurrencyFilterState> {
  final GetCurrencies getCurrencies;
  final GetSelectedCurrency getSelectedCurrency;
  final SaveSelectedCurrency saveSelectedCurrency;

  CurrencyFilterCubit({
    required this.getCurrencies,
    required this.saveSelectedCurrency,
    required this.getSelectedCurrency,
  }) : super(const CurrencyFilterInitial());

  Future<void> loadCurrencies({required BuildContext context, required String? tileName, required EntityData? selectedEntity}) async{

    emit(CurrencyFilterLoading());
    final selectedCurrency = await getSelectedCurrencyFunc(tileName: tileName);
    final Either<AppError, CurrencyEntity> eitherCurrency = await getCurrencies(context);

    eitherCurrency.fold((error) {
      emit(CurrencyFilterError(error.message));
    }, (currencyEntity) {
      List<Currency>? initialList = [...(currencyEntity.list ?? [])];
      if(selectedCurrency!=null){
        initialList..removeWhere((element) => element.id==selectedCurrency?.id)..insert(0, selectedCurrency);

      }

      if(selectedCurrency!=null){
        initialList..removeWhere((element) => element.id==selectedCurrency?.id)..insert(0, selectedCurrency);

        emit(CurrencyFilterChanged(
          currencyFilterList: initialList,
          selectedIPSCurrency: initialList.first,
          selectedCBCurrency: initialList.first,
          selectedNWCurrency: initialList.first,
          selectedPERCurrency: initialList.first,
          selectedIECurrency: initialList.first,
        )
        );
      }else {
        emit(CurrencyFilterChanged(
          currencyFilterList: initialList,
          selectedIPSCurrency: initialList.where((entity) => selectedEntity?.currency == entity.code).toList().first,
          selectedCBCurrency: initialList.where((entity) => selectedEntity?.currency == entity.code).toList().first,
          selectedNWCurrency: initialList.where((entity) => selectedEntity?.currency == entity.code).toList().first,
          selectedPERCurrency: initialList.where((entity) => selectedEntity?.currency == entity.code).toList().first,
          selectedIECurrency: initialList.where((entity) => selectedEntity?.currency == entity.code).toList().first,
        )
        );
      }

    });
  }

  Future<void> selectCurrencyEntity({Currency? currency, required ReportType type, required String? tileName,}) async{

    emit(CurrencyFilterInitial(
        currencyFilterList: state.currencyFilterList,
        selectedIPSCurrency: state.selectedIPSCurrency,
        selectedCBCurrency: state.selectedCBCurrency,
        selectedNWCurrency: state.selectedNWCurrency,
        selectedPERCurrency: state.selectedPERCurrency,
      selectedIECurrency: state.selectedIECurrency,
    ));
    await saveSelectedCurrencyFunc(tileName: tileName, currency: currency);
    emit(CurrencyFilterChanged(
        currencyFilterList: state.currencyFilterList,
        selectedIPSCurrency: type == ReportType.IPS ? currency : state.selectedIPSCurrency,
        selectedCBCurrency: type == ReportType.CB ? currency : state.selectedCBCurrency,
        selectedNWCurrency: type == ReportType.NW ? currency : state.selectedNWCurrency,
        selectedPERCurrency: type == ReportType.PER ? currency : state.selectedPERCurrency,
        selectedIECurrency: type == ReportType.IE ? currency : state.selectedIECurrency,
      )
    );
  }

  Future<CurrencyData?> getSelectedCurrencyFunc({required String? tileName,}) async {
    final Either<AppError, CurrencyData?> selectedCurr = await getSelectedCurrency(GetSelectedCurrencyParams(tileName: tileName));

    return selectedCurr.fold((error) {
      log(error.message);
      return null;
    }, (widget) {
      return widget;
    });
  }

  Future<void> saveSelectedCurrencyFunc({required String? tileName,required Currency? currency,}) async {
    final Either<AppError, void> saveCurr = await saveSelectedCurrency(SaveSelectedCurrencyParams(tileName: tileName, currency: currency));

    saveCurr.fold((error) {
      log(error.message);
    }, (widget) {
      log('Currency saved');
    });
  }
}
