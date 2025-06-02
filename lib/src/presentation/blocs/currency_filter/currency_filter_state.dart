part of 'currency_filter_cubit.dart';

enum ReportType {IPS, CB, NW, PER, IE}

abstract class CurrencyFilterState extends Equatable {
  final List<Currency>? currencyFilterList;
  final Currency? selectedIPSCurrency;
  final Currency? selectedCBCurrency;
  final Currency? selectedNWCurrency;
  final Currency? selectedPERCurrency;
  final Currency? selectedIECurrency;

  const CurrencyFilterState({
    this.currencyFilterList,
    this.selectedIPSCurrency,
    this.selectedCBCurrency,
    this.selectedNWCurrency,
    this.selectedPERCurrency,
    this.selectedIECurrency,
  });

  @override
  List<Object> get props => [];
}

class CurrencyFilterInitial extends CurrencyFilterState {
  final List<Currency>? currencyFilterList;
  final Currency? selectedIPSCurrency;
  final Currency? selectedCBCurrency;
  final Currency? selectedNWCurrency;
  final Currency? selectedPERCurrency;
  final Currency? selectedIECurrency;

  const CurrencyFilterInitial({
    this.currencyFilterList,
    this.selectedIPSCurrency,
    this.selectedCBCurrency,
    this.selectedNWCurrency,
    this.selectedPERCurrency,
    this.selectedIECurrency,
  }) : super(
    currencyFilterList: currencyFilterList,
    selectedIPSCurrency: selectedIPSCurrency,
    selectedCBCurrency: selectedCBCurrency,
    selectedNWCurrency: selectedNWCurrency,
    selectedPERCurrency: selectedPERCurrency,
    selectedIECurrency: selectedIECurrency,
  );
}

class CurrencyFilterChanged extends CurrencyFilterState {
  final List<Currency>? currencyFilterList;
  final Currency? selectedIPSCurrency;
  final Currency? selectedCBCurrency;
  final Currency? selectedNWCurrency;
  final Currency? selectedPERCurrency;
  final Currency? selectedIECurrency;

  const CurrencyFilterChanged({
    required this.currencyFilterList,
    this.selectedIPSCurrency,
    this.selectedCBCurrency,
    this.selectedNWCurrency,
    this.selectedPERCurrency,
    this.selectedIECurrency,
  }) : super(
    currencyFilterList: currencyFilterList,
    selectedIPSCurrency: selectedIPSCurrency,
    selectedCBCurrency: selectedCBCurrency,
    selectedNWCurrency: selectedNWCurrency,
    selectedPERCurrency: selectedPERCurrency,
    selectedIECurrency: selectedIECurrency,
  );
}

class CurrencyFilterLoading extends CurrencyFilterState {}

class CurrencyFilterError extends CurrencyFilterState {
  final String message;

  const CurrencyFilterError(this.message);

  @override
  List<Object> get props => [message];
}