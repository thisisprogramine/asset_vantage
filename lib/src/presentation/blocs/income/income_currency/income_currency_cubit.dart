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
import '../../../../domain/usecases/income/income_filter/selected_currency/get_income_selected_currency.dart';
import '../../../../domain/usecases/income/income_filter/selected_currency/save_income_selected_currency.dart';
import '../income_denomination/income_denomination_cubit.dart';

part 'income_currency_state.dart';

class IncomeCurrencyCubit extends Cubit<IncomeCurrencyState> {
  final GetCurrencies getCurrencies;
  final GetIncomeSelectedCurrency getIncomeSelectedCurrency;
  final SaveIncomeSelectedCurrency saveIncomeSelectedCurrency;

  IncomeCurrencyCubit({
    required this.getCurrencies,
    required this.getIncomeSelectedCurrency,
    required this.saveIncomeSelectedCurrency,
  })
      : super(IncomeCurrencyInitial());

  Future<void> loadIncomeCurrency({required BuildContext context, required IncomeDenominationCubit incomeDenominationCubit, required EntityData? selectedEntity, CurrencyData? favoriteCurrency}) async {
    emit(const IncomeCurrencyLoading());

    final Either<AppError, CurrencyEntity>
        eitherCurrency =
        await getCurrencies(context);
    final CurrencyData? savedCurrency = favoriteCurrency ?? await getIncomeSelectedCurrency();

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
          for(var currency in currencyList) {
            if(currency?.code?.contains(selectedEntity?.currency ?? '-!-!-') ?? false) {
              tempCurrency = currency;
              selectedCurrency = currency;
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

            for(int i = 0; i < (incomeDenominationCubit.state.incomeDenominationList?.length ?? 0); i++) {
              if(incomeDenominationCubit.state.incomeDenominationList?[i]?.id == 2) {
                lacks = incomeDenominationCubit.state.incomeDenominationList?[i];
              }
            }
            incomeDenominationCubit.changeSelectedIncomeDenomination(selectedDenomination: lacks);
          }else {
            DenominationData? millions;

            for(int i = 0; i < (incomeDenominationCubit.state.incomeDenominationList?.length ?? 0); i++) {
              if(incomeDenominationCubit.state.incomeDenominationList?[i]?.id == 3) {
                millions = incomeDenominationCubit.state.incomeDenominationList?[i];
              }
            }
            incomeDenominationCubit.changeSelectedIncomeDenomination(selectedDenomination: millions);
          }
        }
        
        emit(IncomeCurrencyLoaded(
            selectedCurrency: selectedCurrency,
            entityList: currencyList..toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedIncomeCurrency({Currency? selectedCurrency, required IncomeDenominationCubit incomeDenominationCubit}) async {
    List<Currency?> currencyList = state.incomeCurrencyList ?? [];

    currencyList.remove(selectedCurrency);
    currencyList.sort((a, b) => (a?.code ?? '').compareTo((b?.code ?? '')));
    currencyList.insert(0, selectedCurrency);

    emit(IncomeCurrencyInitial());
    emit(IncomeCurrencyLoaded(
        selectedCurrency: selectedCurrency,
        entityList: currencyList.toSet().toList()
    ));
  }
}
