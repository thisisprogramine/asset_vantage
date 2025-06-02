part of 'denomination_filter_cubit.dart';

abstract class DenominationFilterState extends Equatable {
  final List<DenominationData>? denominationFilterList;
  final DenominationData? cashBalanceDenomination;
  final DenominationData? incomeDenomination;
  final DenominationData? expenseDenomination;
  final DenominationData? netWorthDenomination;

  const DenominationFilterState({
    this.denominationFilterList,
    this.cashBalanceDenomination,
    this.expenseDenomination,
    this.incomeDenomination,
    this.netWorthDenomination,
  });

  @override
  List<Object> get props => [];
}

class DenominationFilterInitial extends DenominationFilterState {
  final List<DenominationData>? denominationFilterList;
  final DenominationData? cashBalanceSelectedDenomination;
  final DenominationData? incomeSelectedDenomination;
  final DenominationData? expenseSelectedDenomination;
  final DenominationData? netWorthSelectedDenomination;

  const DenominationFilterInitial({
    this.denominationFilterList,
    this.cashBalanceSelectedDenomination,
    this.incomeSelectedDenomination,
    this.expenseSelectedDenomination,
    this.netWorthSelectedDenomination,
  }) : super(
    denominationFilterList: denominationFilterList,
    cashBalanceDenomination: cashBalanceSelectedDenomination,
    expenseDenomination: expenseSelectedDenomination,
    incomeDenomination: incomeSelectedDenomination,
    netWorthDenomination: netWorthSelectedDenomination,
  );
}

class DenominationFilterChanged extends DenominationFilterState {
  final List<DenominationData>? denominationFilterList;
  final DenominationData? cashBalanceSelectedDenomination;
  final DenominationData? incomeSelectedDenomination;
  final DenominationData? expenseSelectedDenomination;
  final DenominationData? ipsSelectedDenomination;
  final DenominationData? netWorthSelectedDenomination;
  final DenominationData? performanceSelectedDenomination;

  const DenominationFilterChanged({
    required this.denominationFilterList,
    this.cashBalanceSelectedDenomination,
    this.incomeSelectedDenomination,
    this.expenseSelectedDenomination,
    this.ipsSelectedDenomination,
    this.netWorthSelectedDenomination,
    this.performanceSelectedDenomination,
  }) : super(
    denominationFilterList: denominationFilterList,
    cashBalanceDenomination: cashBalanceSelectedDenomination,
    expenseDenomination: expenseSelectedDenomination,
    incomeDenomination: incomeSelectedDenomination,
    netWorthDenomination: netWorthSelectedDenomination,
  );
}

class DenominationFilterLoading extends DenominationFilterState {}

class DenominationFilterError extends DenominationFilterState {
  final String message;

  const DenominationFilterError(this.message);

  @override
  List<Object> get props => [message];
}