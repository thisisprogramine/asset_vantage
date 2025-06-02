import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/usecases/currency/getCurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/currency/currency_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_currency/get_expense_selected_currency.dart';
import '../../../../domain/usecases/expense/expense_filter/selected_currency/save_expense_selected_currency.dart';
import '../expense_denomination/expense_denomination_cubit.dart';

part 'expense_currency_state.dart';

class ExpenseCurrencyCubit extends Cubit<ExpenseCurrencyState> {
  final GetCurrencies getCurrencies;
  final GetExpenseSelectedCurrency getExpenseSelectedCurrency;
  final SaveExpenseSelectedCurrency saveExpenseSelectedCurrency;

  ExpenseCurrencyCubit({
    required this.getCurrencies,
    required this.getExpenseSelectedCurrency,
    required this.saveExpenseSelectedCurrency,
  })
      : super(ExpenseCurrencyInitial());

  Future<void> loadExpenseCurrency({
    required BuildContext context,
    required EntityData? selectedEntity,
    CurrencyData? favoriteCurrency,
    required ExpenseDenominationCubit expenseDenominationCubit
  }) async {
    emit(const ExpenseCurrencyLoading());

    final Either<AppError, CurrencyEntity>
        eitherCurrency =
        await getCurrencies(context);
    final CurrencyData? savedCurrency = favoriteCurrency ?? await getExpenseSelectedCurrency();

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

            for(int i = 0; i < (expenseDenominationCubit.state.expenseDenominationList?.length ?? 0); i++) {
              if(expenseDenominationCubit.state.expenseDenominationList?[i]?.id == 2) {
                lacks = expenseDenominationCubit.state.expenseDenominationList?[i];
              }
            }
            expenseDenominationCubit.changeSelectedExpenseDenomination(selectedDenomination: lacks);
          }else {
            DenominationData? millions;

            for(int i = 0; i < (expenseDenominationCubit.state.expenseDenominationList?.length ?? 0); i++) {
              if(expenseDenominationCubit.state.expenseDenominationList?[i]?.id == 3) {
                millions = expenseDenominationCubit.state.expenseDenominationList?[i];
              }
            }
            expenseDenominationCubit.changeSelectedExpenseDenomination(selectedDenomination: millions);
          }
        }
        
        emit(ExpenseCurrencyLoaded(
            selectedCurrency: selectedCurrency,
            entityList: currencyList..toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedExpenseCurrency({Currency? selectedCurrency, required ExpenseDenominationCubit expenseDenominationCubit}) async {
    List<Currency?> currencyList = state.expenseCurrencyList ?? [];

    currencyList.remove(selectedCurrency);
    currencyList.sort((a, b) => (a?.code ?? '').compareTo((b?.code ?? '')));
    currencyList.insert(0, selectedCurrency);

    emit(ExpenseCurrencyInitial());
    emit(ExpenseCurrencyLoaded(
        selectedCurrency: selectedCurrency,
        entityList: currencyList.toSet().toList()
    ));
  }
}
