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
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_currency/get_cash_balance_selected_currency.dart';
import '../../../../domain/usecases/cash_balance/cash_balance_filters/selected_currency/save_cash_balance_selected_currency.dart';
import '../cash_balance_denomination/cash_balance_denomination_cubit.dart';

part 'cash_balance_currency_state.dart';

class CashBalanceCurrencyCubit extends Cubit<CashBalanceCurrencyState> {
  final GetCurrencies getCurrencies;
  final GetCashBalanceSelectedCurrency getCashBalanceSelectedCurrency;
  final SaveCashBalanceSelectedCurrency saveCashBalanceSelectedCurrency;

  CashBalanceCurrencyCubit({
    required this.getCurrencies,
    required this.getCashBalanceSelectedCurrency,
    required this.saveCashBalanceSelectedCurrency,
  })
      : super(CashBalanceCurrencyInitial());

  Future<void> loadCashBalanceCurrency({
    required BuildContext context,
    required EntityData? selectedEntity,
    required String tileName,
    CurrencyData? favoriteCurrencyData,
    required CashBalanceDenominationCubit cashBalanceDenominationCubit
  }) async {
    emit(const CashBalanceCurrencyLoading());

    final Either<AppError, CurrencyEntity>
        eitherCurrency =
        await getCurrencies(context);
    final CurrencyData? savedCurrency = favoriteCurrencyData ?? await getCashBalanceSelectedCurrency(tileName);

    eitherCurrency.fold(
      (error) {

      },
      (currency) {

        List<Currency?> currencyList = currency.list ?? [];
        Currency? selectedCurrency = (currency.list?.isNotEmpty ?? false) ? currency.list?.first : null;

        if(savedCurrency != null) {
          selectedCurrency = currencyList.firstWhere((currency) => currency?.id == savedCurrency.id);
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

        if(favoriteCurrencyData == null) {
          if(selectedCurrency?.code?.contains("INR") ?? false) {
            DenominationData? lacks;

            for(int i = 0; i < (cashBalanceDenominationCubit.state.cashBalanceDenominationList?.length ?? 0); i++) {
              if(cashBalanceDenominationCubit.state.cashBalanceDenominationList?[i]?.id == 2) {
                lacks = cashBalanceDenominationCubit.state.cashBalanceDenominationList?[i];
              }
            }
            cashBalanceDenominationCubit.changeSelectedCashBalanceDenomination(selectedDenomination: lacks);
          }else {
            DenominationData? millions;

            for(int i = 0; i < (cashBalanceDenominationCubit.state.cashBalanceDenominationList?.length ?? 0); i++) {
              if(cashBalanceDenominationCubit.state.cashBalanceDenominationList?[i]?.id == 3) {
                millions = cashBalanceDenominationCubit.state.cashBalanceDenominationList?[i];
              }
            }
            cashBalanceDenominationCubit.changeSelectedCashBalanceDenomination(selectedDenomination: millions);
          }
        }

        emit(CashBalanceCurrencyLoaded(
            selectedCurrency: selectedCurrency,
            entityList: currencyList..toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedCashBalanceCurrency({Currency? selectedCurrency, required CashBalanceDenominationCubit cashBalanceDenominationCubit}) async {
    List<Currency?> currencyList = state.cashBalanceCurrencyList ?? [];

    currencyList.remove(selectedCurrency);
    currencyList.sort((a, b) => (a?.code ?? '').compareTo((b?.code ?? '')));
    currencyList.insert(0, selectedCurrency);

    emit(CashBalanceCurrencyInitial());
    emit(CashBalanceCurrencyLoaded(
        selectedCurrency: selectedCurrency,
        entityList: currencyList.toSet().toList()
    ));
  }
}
