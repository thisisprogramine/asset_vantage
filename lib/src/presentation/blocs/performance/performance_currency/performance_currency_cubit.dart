import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/usecases/currency/getCurrency.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/currency/currency_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/entities/period/period_enitity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_currency/get_performance_selected_currency.dart';
import '../../../../domain/usecases/performance/performance_filter/selected_currency/save_performance_selected_currency.dart';
import '../performance_denomination/performance_denomination_cubit.dart';

part 'performance_currency_state.dart';

class PerformanceCurrencyCubit extends Cubit<PerformanceCurrencyState> {
  final GetCurrencies getCurrencies;
  final GetPerformanceSelectedCurrency getPerformanceSelectedCurrency;
  final SavePerformanceSelectedCurrency savePerformanceSelectedCurrency;

  PerformanceCurrencyCubit({
    required this.getCurrencies,
    required this.getPerformanceSelectedCurrency,
    required this.savePerformanceSelectedCurrency,
  })
      : super(PerformanceCurrencyInitial());

  Future<void> loadPerformanceCurrency({required BuildContext context, required PerformanceDenominationCubit performanceDenominationCubit, CurrencyData? favoriteCurrency, required EntityData? selectedEntity}) async {
    emit(const PerformanceCurrencyLoading());

    final Either<AppError, CurrencyEntity>
        eitherCurrency =
        await getCurrencies(context);
    final CurrencyData? savedCurrency = favoriteCurrency ?? await getPerformanceSelectedCurrency();

    eitherCurrency.fold(
      (error) {
        
      },
      (currency) {

        List<Currency?> currencyList = currency.list ?? [];
        Currency? selectedCurrency = (currency.list?.isNotEmpty ?? false) ? currency.list?.first : null;

        if(savedCurrency != null) {
          for(var item in currencyList) {
            if(item?.id == savedCurrency.id) {
              selectedCurrency = item;
            }
          }
          currencyList.removeWhere((primaryGrouping) => primaryGrouping?.id == selectedCurrency?.id);
          currencyList.insert(0, selectedCurrency);
        }else {
          Currency? tempCurrency;
          if(favoriteCurrency == null) {
            for(var currency in currencyList) {
              if(currency?.code?.contains(selectedEntity?.currency ?? '-!-!-') ?? false) {
                tempCurrency = currency;
                selectedCurrency = currency;
              }
            }
          }
          if(tempCurrency != null) {
            currencyList.removeWhere((currency) => currency?.id == selectedCurrency?.id);
            currencyList.insert(0, selectedCurrency);
          }
        }

        if(favoriteCurrency == null) {
          if(selectedCurrency?.code?.contains("INR") ?? false) {
            DenominationData? lacks;

            for(int i = 0; i < (performanceDenominationCubit.state.performanceDenominationList?.length ?? 0); i++) {
              if(performanceDenominationCubit.state.performanceDenominationList?[i]?.id == 2) {
                lacks = performanceDenominationCubit.state.performanceDenominationList?[i];
              }
            }
            performanceDenominationCubit.changeSelectedPerformanceDenomination(selectedDenomination: lacks);
          }else {
            DenominationData? millions;

            for(int i = 0; i < (performanceDenominationCubit.state.performanceDenominationList?.length ?? 0); i++) {
              if(performanceDenominationCubit.state.performanceDenominationList?[i]?.id == 3) {
                millions = performanceDenominationCubit.state.performanceDenominationList?[i];
              }
            }
            performanceDenominationCubit.changeSelectedPerformanceDenomination(selectedDenomination: millions);
          }
        }


        emit(PerformanceCurrencyLoaded(
            selectedCurrency: selectedCurrency,
            entityList: currencyList..toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedPerformanceCurrency({Currency? selectedCurrency, required PerformanceDenominationCubit performanceDenominationCubit}) async {
    List<Currency?> currencyList = state.performanceCurrencyList ?? [];

    currencyList.remove(selectedCurrency);
    currencyList.sort((a, b) => (a?.code ?? '').compareTo((b?.code ?? '')));
    currencyList.insert(0, selectedCurrency);

    emit(PerformanceCurrencyInitial());
    emit(PerformanceCurrencyLoaded(
        selectedCurrency: selectedCurrency,
        entityList: currencyList.toSet().toList()
    ));
  }

}
