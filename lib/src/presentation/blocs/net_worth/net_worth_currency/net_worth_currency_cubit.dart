import 'package:asset_vantage/src/domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/usecases/currency/getCurrency.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/currency/currency_model.dart';
import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/currency/currency_entity.dart';
import '../../../../domain/entities/denomination/denomination_entity.dart';
import '../../../../domain/params/no_params.dart';
import '../../../../domain/usecases/net_worth/net_worth_filter/selected_currency/get_net_worth_selected_currency.dart';
import '../../authentication/token/token_cubit.dart';

part 'net_worth_currency_state.dart';

class NetWorthCurrencyCubit extends Cubit<NetWorthCurrencyState> {
  final GetCurrencies getCurrencies;
  final GetNetWorthSelectedCurrency getNetWorthSelectedCurrency;

  NetWorthCurrencyCubit({
    required this.getCurrencies,
    required this.getNetWorthSelectedCurrency,
  })
      : super(NetWorthCurrencyInitial());

  Future<void> loadNetWorthCurrency({
    required BuildContext context,
    CurrencyData? favoriteCurrency,
    required EntityData? selectedEntity,
    required NetWorthDenominationCubit netWorthDenominationCubit,
  }) async {
    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthCurrencyLoading());

    final Either<AppError, CurrencyEntity>
        eitherCurrency =
        await getCurrencies(context);
    final CurrencyData? savedCurrency = favoriteCurrency ?? await getNetWorthSelectedCurrency();

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

        print("selectedCurrency?.code: ${selectedCurrency?.code}");

        if(favoriteCurrency == null) {
          if(selectedCurrency?.code?.contains("INR") ?? false) {
            DenominationData? lacks;

            for(int i = 0; i < (netWorthDenominationCubit.state.netWorthDenominationList?.length ?? 0); i++) {
              if(netWorthDenominationCubit.state.netWorthDenominationList?[i]?.id == 2) {
                lacks = netWorthDenominationCubit.state.netWorthDenominationList?[i];
              }
            }
            netWorthDenominationCubit.changeSelectedNetWorthDenomination(selectedDenomination: lacks);
          }else {
            DenominationData? millions;
            for(int i = 0; i < (netWorthDenominationCubit.state.netWorthDenominationList?.length ?? 0); i++) {
              if(netWorthDenominationCubit.state.netWorthDenominationList?[i]?.id == 3) {
                millions = netWorthDenominationCubit.state.netWorthDenominationList?[i];
              }
            }
            netWorthDenominationCubit.changeSelectedNetWorthDenomination(selectedDenomination: millions);
          }
        }

        emit(NetWorthCurrencyLoaded(
            selectedCurrency: selectedCurrency,
            entityList: currencyList..toSet().toList()
        ));
      },
    );
  }

  Future<void> changeSelectedNetWorthCurrency({Currency? selectedCurrency, required NetWorthDenominationCubit netWorthDenominationCubit,}) async {
    List<Currency?> currencyList = state.netWorthCurrencyList ?? [];

    currencyList.remove(selectedCurrency);
    currencyList.sort((a, b) => (a?.code ?? '').compareTo((b?.code ?? '')));
    currencyList.insert(0, selectedCurrency);

    emit(NetWorthCurrencyInitial());
    emit(NetWorthCurrencyLoaded(
        selectedCurrency: selectedCurrency,
        entityList: currencyList.toSet().toList()
    ));
  }

}
